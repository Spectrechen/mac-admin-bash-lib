# iTerm2 — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/iterm2.sh (maclib::iterm2::*)`` (`maclib::*)::*`)
App: iTerm2 for Mac

## What the vendor says (current, supported installation method)

iTerm2 ships a signed **.zip** from `https://iterm2.com/downloads/stable/latest`. The current build is parsed from the redirect Location header of the zip URL (which ends in `iTerm2-<version>.zip`).

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Zip archive URL | https://iterm2.com/downloads/stable/latest | Installomator `iterm2` label |
| Version source | redirect `Location` header (file name `iTerm2-<version>.zip`) | Installomator |
| Team ID | H7V7XYVQ7D | Installomator |

## Key constraints (from vendor docs)

- The zip extracts to `/Applications/iTerm.app`.
- Managed installs should pin the version and re-deploy the zip.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `iterm2` label.
2. iTerm2 download page: `https://iterm2.com/download`.

## How ``lib/iterm2.sh (maclib::iterm2::*)`` maps to the research

- `url` → the .zip download URL.
- `latest_version` → HEAD-requests the zip URL, extracts the dotted version from the redirect Location.
- `install` → downloads the .zip, extracts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/iTerm.app`.
