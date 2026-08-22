# OpenAI ChatGPT — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/chatgpt.sh (maclib::chatgpt::*)`` (`maclib::*)::*`)
App: ChatGPT for Mac (Apple Silicon)

## What the vendor says (current, supported installation method)

ChatGPT for Mac ships a signed **.dmg** from a persistent OpenAI CDN URL (Apple Silicon only). The current build is read from the public Sparkle appcast.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Disk image URL | https://persistent.oaistatic.com/sidekick/public/ChatGPT_Desktop_public_latest.dmg | Installomator `chatgpt` label |
| Version source | public Sparkle appcast `https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml` | OpenAI |
| Team ID | 2DC432GLL2 | Installomator |

## Key constraints (from vendor docs)

- Apple Silicon only (arm64).
- The .dmg is a single, persistent URL that OpenAI repoints on release.
- Managed installs should pin the version and re-deploy the .dmg.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `chatgpt` label.
2. OpenAI public appcast: `https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml`.

## How ``lib/chatgpt.sh (maclib::chatgpt::*)`` maps to the research

- `latest_version` → GETs the public Sparkle appcast, extracts the version from the `<title>`.
- `url` → the persistent .dmg CDN URL.
- `install` → downloads the .dmg, mounts it, and copies the app bundle to /Applications.
- `is_installed` / `installed_path` → detect `/Applications/ChatGPT.app`.
