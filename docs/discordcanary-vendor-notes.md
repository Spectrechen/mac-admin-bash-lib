# discordcanary — vendor notes

- **Label (Installomator):** `discordcanary`
- **App:** Discord Canary
- **Module:** `lib/communication/discordcanary.sh` (`maclib::discordcanary::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `53Q6R32WPB`

## Vendor source

Discord Canary ships a signed `.dmg` from:

```
https://discord.com/api/download/canary?platform=osx
```

The current build is parsed from the redirect `Location` header of that URL
(the dotted number in the redirected path).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://discord.com/api/download/canary?platform=osx`
- **latest_version:** `0.0.1286` (from redirect path; Discord reports a build number)

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
