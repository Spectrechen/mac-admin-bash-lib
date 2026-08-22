# Mozilla Firefox — Vendor Research Notes — Vendor Research Notes

Entry: ``lib/firefox.sh (maclib::firefox::*)`` (`maclib::*)::*`)
App: Mozilla Firefox for Mac

## What the vendor says (current, supported installation method)

Mozilla ships a signed Firefox **.pkg** from the Mozilla CDN for managed deployment. Firefox ships no built-in updater on macOS, so updates are applied by re-deploying the latest signed package. The current build is read from Mozilla's product-details JSON.

## Concrete vendor-sourced values (verified live)

| Item | Value | Source |
|------|-------|--------|
| Package installer URL | https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx | Installomator `firefoxpkg` label |
| Version source | https://product-details.mozilla.org/1.0/firefox_versions.json (key `LATEST_FIREFOX_VERSION`) | Mozilla product-details JSON |
| Team ID | 43AQ936H96 | Installomator |
| Package ID | org.mozilla.firefox. | Installomator |

## Key constraints (from vendor docs)

- No built-in updater — managed deployments must re-deploy the package to update.
- The `firefox-pkg-latest-ssl` product is Mozilla's signed, SSL-verified package build.

## Vendor sources (where the information came from)

1. Installomator `Installomator.sh` — `firefoxpkg` label.
2. Mozilla product-details JSON: `https://product-details.mozilla.org/1.0/firefox_versions.json`.

## How ``lib/firefox.sh (maclib::firefox::*)`` maps to the research

- `url` → the signed .pkg CDN URL.
- `latest_version` → GETs the product-details JSON, extracts `LATEST_FIREFOX_VERSION`.
- `install` → downloads the .pkg and installs it via Apple `installer`.
- `is_installed` / `installed_path` → detect `/Applications/Firefox.app`.
