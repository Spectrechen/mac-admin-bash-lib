# Signal — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/signal.sh (maclib::signal::*)`` (`maclib::*)::*`)
App: Signal for Mac

## What the vendor says (current, supported installation method)

Signal ships signed **.dmg** installers from `https://updates.signal.org`, resolved via a `latest-mac.yml` manifest. The manifest lists relative file names (e.g. `signal-desktop-mac-universal-8.24.1.dmg`); the full URL is built by prepending the `https://updates.signal.org/desktop/` base. The current build is read from that manifest.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://updates.signal.org/desktop/<relative-file> (built from `latest-mac.yml`) | Installomator `signal` label |
| Version source | latest-mac.yml manifest (`version:` key) | Signal |
| Team ID | U68MSDN6DR | Installomator |

## Key constraints (from vendor docs)

- Signal uses a universal build (arm64 + x86_64).
- The manifest file names embed the version number.
- Managed installs should pin the version and re-deploy the .dmg.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `signal` label.
2. Signal `latest-mac.yml`: `https://updates.signal.org/desktop/latest-mac.yml`.

## How ``lib/signal.sh (maclib::signal::*)`` maps to the research

- `latest_version` → GETs `latest-mac.yml`, extracts the `version:` value.
- `url` → GETs `latest-mac.yml`, builds the full .dmg URL from the relative universal file name.
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/Signal.app`.
