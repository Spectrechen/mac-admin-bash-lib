# webexteams — vendor notes

- **Label (Installomator):** `webexteams`
- **App:** Webex
- **Module:** `lib/communication/webexteams.sh` (`maclib::webexteams::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `DE8Y96K9QP`

## Vendor source

Webex ships a signed `.dmg` from `binaries.webex.com`, with separate Apple
Silicon and Intel build directories:

```
https://binaries.webex.com/webex-macos-apple-silicon/Webex.dmg   (arm64)
https://binaries.webex.com/webex-macos-intel/Webex.dmg           (x86_64)
```

The current build is parsed from the Webex "What's New" help page.

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://binaries.webex.com/webex-macos-apple-silicon/Webex.dmg` (arm64)
  or `https://binaries.webex.com/webex-macos-intel/Webex.dmg` (x86_64)
- **latest_version:** `46.8.0.35631`

## Install / update / uninstall

- **install:** download `.dmg`, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
