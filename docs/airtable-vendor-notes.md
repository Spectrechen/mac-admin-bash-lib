# airtable — vendor notes

- **Label (Installomator):** `airtable`
- **App:** Airtable
- **Module:** `lib/communication/airtable.sh` (`maclib::communication::airtable::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `E22RZMX62E`

## Vendor source

Airtable ships a signed `.dmg` from a static URL (Installomator `airtable`
label):

```
https://static.airtable.com/download/AirtableInstaller.dmg
```

The URL carries no build number, so there is **no vendor version endpoint** —
`latest_version()` returns non-zero (documented constraint).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://static.airtable.com/download/AirtableInstaller.dmg` (HTTP/2 200, ~227 MB)
- **latest_version:** none (no vendor version source)

## Install / update / uninstall

- **install:** download the dmg, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
