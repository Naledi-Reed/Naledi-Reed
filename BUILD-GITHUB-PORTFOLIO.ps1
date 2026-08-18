[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$KeepProjectCopies
)

$ErrorActionPreference = 'Stop'

function Require-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found. Install Git and GitHub CLI (gh), then run this script again."
    }
}

Require-Command git
Require-Command gh

$root = (git rev-parse --show-toplevel).Trim()
if (-not $root) { throw 'Run this script from a clone of Naledi-Reed/Naledi-Reed.' }
Set-Location $root

$login = gh api user --jq .login 2>$null
if ($LASTEXITCODE -ne 0 -or -not $login) {
    throw "GitHub CLI is not authenticated. Run 'gh auth login' once, then rerun this script."
}
if ($login -ne 'Naledi-Reed') {
    throw "Authenticated GitHub account is '$login', expected 'Naledi-Reed'."
}

$repoRoot = 'Naledi-Reed'
$manifestPath = Join-Path $root 'PORTFOLIO-REPO-MANIFEST.json'
if (-not (Test-Path $manifestPath)) { throw 'PORTFOLIO-REPO-MANIFEST.json is missing.' }
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

# Safety: DBD is permanently excluded from the automated public build.
if ($manifest.dbd_policy -ne 'EXCLUDED') { throw 'DBD policy was changed. Refusing to publish.' }

$repo = gh repo view "$repoRoot/Naledi-Reed" --json nameWithOwner --jq .nameWithOwner
if (-not $repo) { throw 'Could not access profile repository.' }

$tag = "portfolio-before-standalone-$((Get-Date).ToUniversalTime().ToString('yyyyMMdd-HHmmss'))"
if ($DryRun) {
    Write-Host "[DRY RUN] Would create backup tag $tag"
} else {
    git tag $tag
    git push origin $tag
}

$tempBase = Join-Path $env:TEMP "naledi-github-portfolio"
if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force }
New-Item -ItemType Directory -Path $tempBase | Out-Null

$created = @()
try {
    foreach ($project in $manifest.standalone_repositories) {
        $source = Join-Path $root $project.source
        if (-not (Test-Path $source)) {
            throw "Required project folder is missing: $($project.source)"
        }

        $target = Join-Path $tempBase $project.repository
        Copy-Item $source $target -Recurse -Force
        Remove-Item (Join-Path $target '.git') -Recurse -Force -ErrorAction SilentlyContinue

        Set-Location $target
        git init -b main | Out-Null
        git add .
        git commit -m 'Initial portfolio publication' | Out-Null

        $fullName = "$repoRoot/$($project.repository)"
        $exists = gh repo view $fullName --json nameWithOwner --jq .nameWithOwner 2>$null
        if ($LASTEXITCODE -eq 0 -and $exists) {
            throw "Repository already exists: $fullName. Nothing was overwritten."
        }

        if ($DryRun) {
            Write-Host "[DRY RUN] Would create $fullName"
        } else {
            gh repo create $fullName --public --description $project.description --source . --remote origin --push
            foreach ($topic in $project.topics) {
                gh repo edit $fullName --add-topic $topic | Out-Null
            }
        }
        $created += $fullName
        Write-Host "Published: $fullName"
    }

    # Update the profile README links only after all standalone repositories publish.
    Set-Location $root
    $readmePath = Join-Path $root 'README.md'
    $readme = Get-Content $readmePath -Raw
    foreach ($project in $manifest.standalone_repositories) {
        $slug = $project.repository
        $source = [regex]::Escape($project.source.TrimEnd('/').Replace('\','/'))
        $readme = $readme -replace "\]\($source/\)", "](/$repoRoot/$slug)"
    }

    if ($DryRun) {
        Write-Host '[DRY RUN] Would update profile README with standalone repository links.'
    } else {
        Set-Content -Path $readmePath -Value $readme -Encoding UTF8
        git add README.md
        git commit -m 'Link profile to standalone project repositories' | Out-Null
        git push origin main
    }

    if (-not $KeepProjectCopies -and -not $DryRun) {
        foreach ($project in $manifest.standalone_repositories) {
            if (Test-Path (Join-Path $root $project.source)) {
                git rm -r -- $project.source | Out-Null
            }
        }
        git commit -m 'Move published projects out of profile hub' | Out-Null
        git push origin main
    }

    Write-Host ''
    Write-Host 'PORTFOLIO BUILD COMPLETE' -ForegroundColor Green
    Write-Host "Profile: https://github.com/$repoRoot/Naledi-Reed"
    foreach ($item in $created) { Write-Host "Project: https://github.com/$item" }
}
finally {
    Set-Location $root
    if (Test-Path $tempBase) { Remove-Item $tempBase -Recurse -Force }
}
