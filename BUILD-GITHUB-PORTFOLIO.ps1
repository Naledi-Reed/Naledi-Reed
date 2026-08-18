[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$KeepProjectCopies
)

$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found. Install Git and GitHub CLI (gh), then rerun."
    }
}

Require-Command git
Require-Command gh

$root = (git rev-parse --show-toplevel).Trim()
if (-not $root) { throw 'Run this script from a clone of Naledi-Reed/Naledi-Reed.' }
Set-Location $root

# Confirm identity before making any public repositories.
$login = gh api user --jq .login 2>$null
if ($LASTEXITCODE -ne 0 -or -not $login) {
    throw "GitHub CLI is not authenticated. Run 'gh auth login' once, then rerun."
}
if ($login -ne 'Naledi-Reed') {
    throw "Authenticated GitHub account is '$login', expected 'Naledi-Reed'."
}

$manifestPath = Join-Path $root 'PORTFOLIO-REPO-MANIFEST.json'
if (-not (Test-Path $manifestPath)) { throw 'PORTFOLIO-REPO-MANIFEST.json is missing.' }
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

if ($manifest.dbd_policy -ne 'EXCLUDED') {
    throw 'DBD publication policy was changed. Refusing to publish.'
}

$profileRepo = $manifest.profile_repository
$profile = gh repo view $profileRepo --json nameWithOwner --jq .nameWithOwner
if (-not $profile) { throw "Cannot access $profileRepo." }

# Refuse to publish duplicate repositories rather than overwriting them.
$existing = @()
foreach ($project in $manifest.standalone_repositories) {
    $fullName = "$($manifest.owner)/$($project.repository)"
    $probe = gh repo view $fullName --json nameWithOwner --jq .nameWithOwner 2>$null
    if ($LASTEXITCODE -eq 0 -and $probe) { $existing += $fullName }
}
if ($existing.Count -gt 0 -and -not $DryRun) {
    throw "The following target repositories already exist. Nothing was overwritten:`n$($existing -join "`n")"
}

$tag = "portfolio-before-standalone-$((Get-Date).ToUniversalTime().ToString('yyyyMMdd-HHmmss'))"
if (-not $DryRun) {
    git tag $tag
    git push origin $tag
}

$tempBase = Join-Path $env:TEMP "naledi-github-portfolio"
if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force }
New-Item -ItemType Directory -Path $tempBase | Out-Null

$published = @()
try {
    foreach ($project in $manifest.standalone_repositories) {
        $source = Join-Path $root $project.source
        if (-not (Test-Path $source)) {
            throw "Required curated project folder is missing: $($project.source)"
        }

        $target = Join-Path $tempBase $project.repository
        Copy-Item $source $target -Recurse -Force
        Remove-Item (Join-Path $target '.git') -Recurse -Force -ErrorAction SilentlyContinue

        if (-not (Test-Path (Join-Path $target 'README.md'))) {
            throw "Project has no README.md: $($project.source)"
        }

        # Defensive check: DBD never enters a standalone build.
        $files = Get-ChildItem $target -Recurse -File | ForEach-Object { $_.FullName }
        foreach ($file in $files) {
            if ((Get-Content $file -Raw -ErrorAction SilentlyContinue) -match '(?i)DBD261|database-sql-server|database-systems') {
                throw "Blocked DBD content detected in $($project.source): $file"
            }
        }

        Set-Location $target
        git init -b main | Out-Null
        git add .
        git commit -m 'Initial portfolio publication' | Out-Null

        $fullName = "$($manifest.owner)/$($project.repository)"
        if ($DryRun) {
            Write-Host "[DRY RUN] Would create $fullName"
        } else {
            gh repo create $fullName --public --description $project.description --source . --remote origin --push
            foreach ($topic in $project.topics) {
                gh repo edit $fullName --add-topic $topic | Out-Null
            }
        }
        $published += $project.repository
        Write-Host "Published: $fullName"
    }

    Set-Location $root

    # Make the profile point directly to real standalone repositories.
    $readmePath = Join-Path $root 'README.md'
    $readme = Get-Content $readmePath -Raw
    foreach ($project in $manifest.standalone_repositories) {
        $repoUrl = "https://github.com/$($manifest.owner)/$($project.repository)"
        $folderPattern = [regex]::Escape("projects/$($project.repositorySourceName)")
        $readme = $readme -replace "\[[^\]]+\]\([^)]*projects/[^)]*\)", {
            param($m)
            $text = $m.Value
            if ($text -match $folderPattern) { return $text }
            return $text
        }
    }

    # Replace explicit project links by their standalone URLs.
    foreach ($project in $manifest.standalone_repositories) {
        $sourceFolder = $project.source.TrimEnd('/').Replace('\','/')
        $repoUrl = "https://github.com/$($manifest.owner)/$($project.repository)"
        $readme = $readme.Replace("($sourceFolder/)", "($repoUrl)")
        $readme = $readme.Replace("($sourceFolder)", "($repoUrl)")
    }

    # Leave the profile hub minimal after successful publication.
    $cleanupPaths = @(
        'projects',
        'scripts',
        'BELGIUM-CAMPUS-INVENTORY.md',
        'PORTFOLIO-OPERATING-RULES.md',
        'PROJECT-MAP.md',
        'SECURITY-POSITIONING.md'
    )

    if ($DryRun) {
        Write-Host '[DRY RUN] Would update README and clean staging/utility files.'
    } else {
        Set-Content -Path $readmePath -Value $readme -Encoding UTF8
        git add README.md
        git commit -m 'Link profile to standalone project repositories' | Out-Null
        git push origin main

        if (-not $KeepProjectCopies) {
            foreach ($path in $cleanupPaths) {
                if (Test-Path (Join-Path $root $path)) {
                    git rm -r -- $path | Out-Null
                }
            }
            git commit -m 'Clean profile hub after standalone publication' | Out-Null
            git push origin main
        }
    }

    Write-Host ''
    Write-Host 'PORTFOLIO BUILD COMPLETE' -ForegroundColor Green
    Write-Host "Profile: https://github.com/$($manifest.owner)/Naledi-Reed"
    foreach ($name in $published) {
        Write-Host "Project: https://github.com/$($manifest.owner)/$name"
    }
}
finally {
    Set-Location $root
    if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force }
}
