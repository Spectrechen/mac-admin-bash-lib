# skype — vendor notes

- **Label (Installomator):** `skype`
- **App:** Skype
- **Module:** `lib/communication/skype.sh` (`maclib::skype::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `AL798K98FX`

## Vendor source

Skip ships a signed `.dmg` from `get.skype.com/go/getskype-skypeformac`. The
current build is parsed from the redirect `Location` header of that URL (the
dotted number embedded in the archive file name).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://get.skype.com/go/getskype-skypeformac`
- **latest_version:** none — the vendor endpoint returns no redirect headers in
  automated/geo-restricted contexts; no version could be extracted. Documented
  as no clean version rather than guessed.

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
