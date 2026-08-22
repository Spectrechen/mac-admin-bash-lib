# Dropbox — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/dropbox.sh (maclib::dropbox::*)`` (`maclib::*)::*`)
App: Dropbox for Mac

## What the vendor says (current, supported installation method)

Dropbox ships a signed **.dmg** from `https://www.dropbox.com/download?plat=mac`. The current build is parsed from the redirect Location header of the download URL.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://www.dropbox.com/download?plat=mac&full=1 | Installomator `dropbox` label |
| Version source | redirect `Location` header (dotted number in the file name) | Installomator |
| Team ID | G7HH3F8CAK | Installomator |

## Key constraints (from vendor docs)

- Dropbox runs a background sync client; managed installs should pin the version.
- The installer mounts a .dmg and copies `/Applications/Dropbox.app`.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `dropbox` label.

## How ``lib/dropbox.sh (maclib::dropbox::*)`` maps to the research

- `url` → the signed .dmg download URL.
- `latest_version` → HEAD-requests the download URL, extracts the dotted version from the redirect Location.
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/Dropbox.app`.
