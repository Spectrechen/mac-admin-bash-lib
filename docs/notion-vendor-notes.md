# Notion — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/notion.sh (maclib::notion::*)`` (`maclib::*)::*`)
App: Notion for Mac

## What the vendor says (current, supported installation method)

Notion ships a signed **.dmg** from `https://www.notion.so/desktop/mac/download`. The current build is parsed from the redirect Location header of the download URL.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://www.notion.so/desktop/mac/download | Installomator `notion` label |
| Version source | redirect `Location` header (dotted number in the file name) | Installomator |
| Team ID | LBQJ96FQ8D | Installomator |

## Key constraints (from vendor docs)

- Notion runs a background sync client; managed installs should pin the version.
- The installer mounts a .dmg and copies `/Applications/Notion.app`.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `notion` label.

## How ``lib/notion.sh (maclib::notion::*)`` maps to the research

- `url` → the signed .dmg download URL.
- `latest_version` → HEAD-requests the download URL, extracts the dotted version from the redirect Location.
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/Notion.app`.
