$ErrorActionPreference = 'Stop'

Write-Host "=== NALEDI PORTFOLIO BUILDER ===" -ForegroundColor Cyan
Write-Host "Public projects are rebuilt from the approved set. DBD261 is excluded by policy." -ForegroundColor Yellow

python scripts/build_portfolio.py --sync

if ($LASTEXITCODE -ne 0) {
    throw "Portfolio build failed. Nothing was pushed."
}

$branch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($branch)) {
    throw "Could not determine the current Git branch."
}

Write-Host "Pushing branch: $branch" -ForegroundColor Green
git push origin $branch

if ($LASTEXITCODE -ne 0) {
    throw "Git push failed. Check your GitHub authentication and remote configuration."
}

Write-Host "Portfolio build + push complete." -ForegroundColor Green
Write-Host "Review the GitHub repository before publishing any new academic evidence." -ForegroundColor Gray
