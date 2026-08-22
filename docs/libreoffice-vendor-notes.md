# LibreOffice — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/libreoffice.sh (maclib::libreoffice::*)`` (`maclib::*)::*`)
App: LibreOffice for Mac

## What the vendor says (current, supported installation method)

LibreOffice ships signed **.dmg** installers from the The Document Foundation CDN, with arm64/x86_64 variants. The current build is read from the download directory listing. The .dmg names embed the version and architecture.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://download.documentfoundation.org/libreoffice/stable/<version>/mac/<arch>/LibreOffice_<version>_MacOS_<arch>.dmg | Installomator `libreoffice` label |
| Version source | download directory listing (`https://download.documentfoundation.org/libreoffice/stable/`) | The Document Foundation |
| Team ID | 7P5S3ZLCN7 | Installomator |

## Key constraints (from vendor docs)

- Two builds: arm64 (aarch64) and x86_64 — the module selects by `arch`.
- Managed installs should pin the version and re-deploy the .dmg.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `libreoffice` label.
2. LibreOffice download pages: `https://download.documentfoundation.org/libreoffice/stable/`.

## How ``lib/libreoffice.sh (maclib::libreoffice::*)`` maps to the research

- `latest_version` → GETs the stable directory listing, extracts the latest build.
- `url` → builds the arch-aware .dmg URL from the current version.
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/LibreOffice.app`.
