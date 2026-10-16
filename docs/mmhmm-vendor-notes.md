# mmhmm — vendor notes

- **Label (Installomator):** `mmhmm|mmhmm-desktop`
- **App:** mmhmm
- **Module:** `lib/communication/mmhmm.sh` (`maclib::mmhmm::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `M3KUT44L48`

## Vendor source

mmhmm ships a signed `.pkg` from:

```
https://updates.mmhmm.app/mac/hybrid/mmhmm.pkg
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://updates.mmhmm.app/mac/hybrid/mmhmm.pkg`
- **latest_version:** none — mmhmm publishes no version string (Installomator
  `appNewVersion=""`); reported empty rather than guessed.

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
