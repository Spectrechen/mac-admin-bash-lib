# jitsimeet — vendor notes

- **Label (Installomator):** `jitsimeet`
- **App:** Jitsi Meet
- **Module:** `lib/communication/jitsimeet.sh` (`maclib::jitsimeet::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `FC967L3QRG`

## Vendor source

Jitsi Meet ships a signed `.dmg` from its GitHub releases:

```
https://github.com/Jitsi/jitsi-meet-electron/releases/latest
```

The macOS asset is `jitsi-meet.dmg`; the version is the release `tag_name`
(e.g. `v2026.8.0`).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://github.com/jitsi/jitsi-meet-electron/releases/download/v2026.8.0/jitsi-meet.dmg`
- **latest_version:** `2026.8.0`

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
