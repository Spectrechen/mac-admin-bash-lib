# soundly-placeit — vendor notes

- **Label (Installomator):** `soundly-placeit`
- **App:** Placeit (Soundly plugin)
- **Module:** `lib/communication/soundly-placeit.sh` (`maclib::communication::soundly-placeit::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `67Y6N7VTDG`

## Vendor source

Placeit ships a signed `.pkg` from Google Cloud Storage (Installomator
`soundly-placeit` label):

```
https://storage.googleapis.com/soundly-plugins/Placeit.pkg
```

The URL carries no build number, so there is **no vendor version endpoint** —
`latest_version()` returns non-zero (documented constraint).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://storage.googleapis.com/soundly-plugins/Placeit.pkg` (HTTP/2 200)
- **latest_version:** none (no vendor version source)

## Install / update / uninstall

- **install:** download the pkg and install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
