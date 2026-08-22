# Google Chrome — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/chrome.sh (maclib::chrome::*)`` (`maclib::*)::*`)
App: Google Chrome for Mac

## What the vendor says (current, supported installation method)

Google distributes Chrome for Mac as a signed Apple **.pkg** installer from Google's CDN. Managed deployment installs the package with any standard software distribution tool (Jamf Pro, Microsoft Intune, Munki, AutoPkg). The current build is read from the Google Chrome version-history API. Updates are delivered by the Google Software Update agent.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Package installer URL | `https://dl.google.com/chrome/mac/stable/accept_tos%3D.../googlechrome.pkg` | Installomator `googlechromepkg` label |
| Version source | `https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases` (JSON) | Google Chrome version-history API |
| Team ID | EQHXZ8M8AV | Installomator |
| Package ID | com.google.chrome. | Installomator |
| Update tool | `/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/...` | Installomator |

## Key constraints (from vendor docs)

- The package installs into `/Applications/Google Chrome.app`.
- Managed installs should pin a version; Chrome auto-updates via the background agent unless disabled.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `googlechromepkg` label (github.com/Installomator/Installomator).
2. Google Chrome version-history API: `https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases`.

## How ``lib/chrome.sh (maclib::chrome::*)`` maps to the research

- `url` → the signed .pkg CDN URL.
- `latest_version` → GETs the version-history API, extracts the newest stable build (source #2).
- `install` → downloads the .pkg and installs it via Apple `installer`.
- `update` → runs the Google Software Update agent (source #2).
- `is_installed` / `installed_path` → detect `/Applications/Google Chrome.app`.
