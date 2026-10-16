# discord — vendor notes

- **Label (Installomator):** `discord`
- **App:** Discord
- **Module:** `lib/communication/discord.sh` (`maclib::discord::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `53Q6R32WPB`

## Vendor source

Discord ships a signed `.dmg` from:

```
https://discordapp.com/api/download?platform=osx
```

The current build is parsed from the redirect `Location` header of that URL
(the dotted number in the redirected path).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://discordapp.com/api/download?platform=osx`
- **latest_version:** `0.0.409` (from redirect path; Discord reports a build number)

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
