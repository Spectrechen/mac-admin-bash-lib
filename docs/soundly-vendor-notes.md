# soundly — vendor notes

- **Label (Installomator):** `soundly`
- **App:** Soundly
- **Module:** `lib/communication/soundly.sh` (`maclib::communication::soundly::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `67Y6N7VTDG`

## Vendor source

Soundly ships signed `.dmg` installers from Google Cloud Storage, with a build
per architecture (Installomator `soundly` label):

```
x86_64: https://storage.googleapis.com/soundlyapp/Soundly.dmg
arm64:  https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg
```

The URL carries no build number, so there is **no vendor version endpoint** —
`latest_version()` returns non-zero (documented constraint).

## Concrete values (2026-08-25)

- **suite_installer_url (x86_64):** `https://storage.googleapis.com/soundlyapp/Soundly.dmg` (HTTP/2 200, ~97 MB)
- **suite_installer_url (arm64):** `https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg` (HTTP/2 200)
- **latest_version:** none (no vendor version source)

## Install / update / uninstall

- **install:** download the dmg (arch-selected), mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
