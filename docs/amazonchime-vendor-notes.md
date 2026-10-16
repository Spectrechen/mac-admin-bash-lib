# amazonchime — vendor notes

- **Label (Installomator):** `amazonchime`
- **App:** Amazon Chime
- **Module:** `lib/communication/amazonchime.sh` (`maclib::amazonchime::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `94KV3E626L`

## Vendor source

Amazon Chime ships a signed `.dmg` from:

```
https://clients.chime.aws/mac/latest
```

The current build is parsed from the redirect `Location` header of that URL
(the dotted number before the `.dmg`).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://clients.chime.aws/mac/latest`
- **latest_version:** `5.23.22533`

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
