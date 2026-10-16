# anydesk — vendor notes

- **Label (Installomator):** `anydesk`
- **App:** AnyDesk
- **Module:** `lib/communication/anydesk.sh` (`maclib::anydesk::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `KHRWM533LU`

## Vendor source

AnyDesk ships a signed `.dmg` from:

```
https://download.anydesk.com/anydesk.dmg
```

The current build is parsed from `https://download.anydesk.com/changelog.txt`
(first `(macOS)` entry).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://download.anydesk.com/anydesk.dmg`
- **latest_version:** `9.7.3`

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
