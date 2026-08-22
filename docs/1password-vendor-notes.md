# 1Password — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/1password.sh (maclib::1password::*)`` (`maclib::*)::*`)
App: 1Password for Mac

## What the vendor says (current, supported installation method)

1Password ships a signed **.pkg** installer from `https://downloads.1password.com`. IT deployment installs the package into /Applications (bundle ID `com.1password.1password`, group/team ID `2BUA8C4S2C`). The current build is read from 1Password's releases XML feed.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Package installer URL | https://downloads.1password.com/mac/1Password.pkg | Installomator `1password8` label |
| Version source | https://releases.1password.com/mac/stable/index.xml (releases XML feed) | 1Password deploy docs |
| Team ID | 2BUA8C4S2C | Installomator |
| Bundle ID | com.1password.1password | 1Password deploy docs |

## Key constraints (from vendor docs)

- Managed installs should pin a version; 1Password auto-updates unless disabled.
- The package installs into `/Applications/1Password.app`.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `1password8` label.
2. 1Password releases XML: `https://releases.1password.com/mac/stable/index.xml`.

## How ``lib/1password.sh (maclib::1password::*)`` maps to the research

- `url` → the signed .pkg installer URL.
- `latest_version` → GETs the releases XML, extracts the latest build number.
- `install` → downloads the .pkg and installs it via Apple `installer`.
- `is_installed` / `installed_path` → detect `/Applications/1Password.app`.
