# mmhmm-studio — vendor notes

- **Label (Installomator):** `mmhmm-studio`
- **App:** mmhmm Studio
- **Module:** `lib/communication/mmhmm-studio.sh` (`maclib::mmhmm-studio::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `M3KUT44L48`

## Vendor source

mmhmm Studio ships a signed `.pkg` from:

```
https://updates.mmhmm.app/mac/mmhmmStudio.pkg
```

The current build is parsed from the mmhmm Studio help/release page
(`https://help.mmhmm.app/hc/en-us/articles/4420969712151-mmhmm-Studio-Mac-only-`).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://updates.mmhmm.app/mac/mmhmmStudio.pkg`
- **latest_version:** none — the help page is bot/geo-blocked in automated
  contexts (0-byte response); no version could be extracted. Documented as no
  clean version rather than guessed.

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
