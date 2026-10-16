# aircall — vendor notes

- **Label (Installomator):** `aircall`
- **App:** Aircall Workspace
- **Module:** `lib/communication/aircall.sh` (`maclib::aircall::*`)
- **Installer type:** zip (Electron auto-updater artifact)
- **Apple Developer Team ID:** `3ML357Q795`

## Vendor source

Aircall is an Electron app updated through its own endpoint:

```
https://electron.aircall.io/update/osx/1.0.0?channel=stable
```

The endpoint returns JSON whose `url` field is the zip installer and whose
`name` field is the current version.

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://download-electron.aircall.io/Aircall-3.1.66.zip`
- **latest_version:** `3.1.66`

## Install / update / uninstall

- **install:** download the zip, unzip, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
