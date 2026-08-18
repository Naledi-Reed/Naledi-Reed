# Windows — One-Command Portfolio Publication

The profile repository is now prepared to split the curated project folders into standalone GitHub repositories.

## One-time setup

Open PowerShell and install GitHub CLI if it is not already installed:

```powershell
winget install --id GitHub.cli -e
```

Restart PowerShell, then authenticate once:

```powershell
gh auth login
```

Choose GitHub.com, HTTPS, and browser authentication.

## Publish everything

From the root of the cloned `Naledi-Reed/Naledi-Reed` repository:

```powershell
.\BUILD-GITHUB-PORTFOLIO.ps1
```

The script will:

1. Verify that the authenticated account is `Naledi-Reed`.
2. Create a safety tag before changing the profile hub.
3. Create the approved standalone repositories.
4. Copy only the approved project folders into those repositories.
5. Set repository descriptions and topics.
6. Update the profile README with direct repository links.
7. Remove the duplicate project folders from the profile hub after successful publication.
8. Leave DBD261 excluded.
9. Leave the existing `INL261-AI-Assisted-Animated-Website-` repository untouched.
10. Leave the future SOC homelab repository untouched until the lab is actually built.

## Dry run

To preview the actions without creating repositories or changing the profile hub:

```powershell
.\BUILD-GITHUB-PORTFOLIO.ps1 -DryRun
```

## Keep project copies in the profile repository

The default behaviour removes project copies from the profile hub after successful publication so the profile repository stays clean. To keep them:

```powershell
.\BUILD-GITHUB-PORTFOLIO.ps1 -KeepProjectCopies
```

## Safety

The script refuses to publish if the manifest's DBD policy is changed. It also refuses to overwrite an existing standalone repository.
