# Portfolio Automation

## One command on Windows

```powershell
.\BUILD-GITHUB-PORTFOLIO.ps1
```

This workflow is designed to make the public portfolio repeatable:

1. Run the portfolio builder.
2. Rebuild the approved project index.
3. Exclude DBD261 from all generated public content.
4. Run privacy and obvious-secret checks.
5. Validate that approved project documentation exists.
6. Create a local Git commit when files changed.
7. Push the current branch when Git credentials are configured.

## Approved public project set

- CNA261 — Cloud Native Student Qualifier
- OPS261 — Hybrid Windows Infrastructure
- OPS262 — PowerShell Administration Toolkit
- IOT261 — Human Detection Probe
- PMM261 — AquaSense
- INL261 — Information Networking
- ERP261 — ERP Case Study
- SOC Lab — practical security learning track

## Explicitly excluded

- DBD261
- raw marks
- student numbers
- private lecturer correspondence
- group-member personal information
- credentials/API keys
- unredacted academic submissions

## Important limitation

Automation can validate, organise and publish approved portfolio artefacts. It should not automatically publish arbitrary new academic files. New coursework needs to be represented by a curated public artefact before it is added to the approved set.
