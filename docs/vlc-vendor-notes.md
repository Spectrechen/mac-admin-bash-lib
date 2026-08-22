# VLC media player — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/vlc.sh (maclib::vlc::*)`` (`maclib::*)::*`)
App: VLC media player for Mac

## What the vendor says (current, supported installation method)

VLC ships signed **.dmg** installers from the VideoLAN CDN at `https://get.videolan.org/vlc/<version>/macosx/`. The current build is read from the VLC download page. The .dmg is a universal (arm64 + x86_64) build.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://get.videolan.org/vlc/<version>/macosx/vlc-<version>-universal.dmg | Installomator `vlc` label |
| Version source | https://www.videolan.org/vlc/ page (JSON `latestVersion` key) | VideoLAN |
| Team ID | 75GAHG3SZQ | Installomator |

## Key constraints (from vendor docs)

- VLC is a universal build (works on both Apple Silicon and Intel).
- Managed installs should pin the version and re-deploy the .dmg.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `vlc` label.
2. VideoLAN download pages: `https://www.videolan.org/vlc/`.

## How ``lib/vlc.sh (maclib::vlc::*)`` maps to the research

- `latest_version` → GETs the VLC download page, extracts the latest build.
- `url` → builds the .dmg URL from the current version (universal build).
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/VLC.app`.
