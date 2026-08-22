# Zoom — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/zoom.sh (maclib::zoom::*)`` (`maclib::*)::*`)
App: Zoom for Mac

## What the vendor says (current, supported installation method)

Zoom ships a signed installer package (ZoomInstallerIT.pkg) from `https://zoom.us/client/latest/`. The current version is embedded in the redirect Location header of that URL. Zoom ships a self-updating installer, so updates are applied by re-installing the latest package.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Package installer URL | https://zoom.us/client/latest/ZoomInstallerIT.pkg | Installomator `zoom` label |
| Version source | redirect `Location` header of the installer URL (dotted number) | Installomator |
| Team ID | BJ4HAAB9B3 | Installomator |
| Package ID | com.zoom.universalclient. | Installomator |

## Key constraints (from vendor docs)

- Zoom bundles a self-updating installer that runs in the background.
- For managed deployments, pin the version and re-deploy the package.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `zoom` label.
2. Zoom download page: `https://zoom.us/client/latest`.

## How ``lib/zoom.sh (maclib::zoom::*)`` maps to the research

- `url` → the signed .pkg installer URL.
- `latest_version` → HEAD-requests the installer, extracts the dotted version from the redirect Location.
- `install` → downloads the .pkg and installs it via Apple `installer`.
- `is_installed` / `installed_path` → detect `/Applications/Zoom.app`.
