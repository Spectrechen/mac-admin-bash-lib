# Figma — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/figma.sh (maclib::figma::*)`` (`maclib::*)::*`)
App: Figma for Mac

## What the vendor says (current, supported installation method)

Figma ships signed **.zip** archives from `https://desktop.figma.com`. The arm64 and x86_64 builds are on separate URLs. The current build is read from the `RELEASE.json` manifest.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Zip archive URL | arm64: `https://desktop.figma.com/mac-arm/Figma.zip` / x86_64: `https://desktop.figma.com/mac/Figma.zip` | Installomator `figma` label |
| Version source | https://desktop.figma.com/mac/RELEASE.json (JSON `version` key) | Figma |
| Team ID | T8RA8NE3B7 | Installomator |

## Key constraints (from vendor docs)

- Two builds: arm64 and x86_64 — the module selects by `arch`.
- The zip extracts to `/Applications/Figma.app`.
- Managed installs should pin the version and re-deploy the zip.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `figma` label.
2. Figma `RELEASE.json`: `https://desktop.figma.com/mac/RELEASE.json`.

## How ``lib/figma.sh (maclib::figma::*)`` maps to the research

- `latest_version` → GETs `RELEASE.json`, extracts the build.
- `url` → selects the arm64 or x86_64 zip URL by `arch`.
- `install` → downloads the .zip, extracts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/Figma.app`.
