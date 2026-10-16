# airtame — vendor notes

- **Label (Installomator):** `airtame`
- **App:** Airtale
- **Module:** `lib/communication/airtame.sh` (`maclib::communication::airtame::*`)
- **Installer type:** dmg
- **Apple Developer Team ID:** `4TPSP88HN2`

## Vendor source

Airtale serves the current build through a redirect endpoint (Installomator
`airtame` label):

```
https://downloads-website.airtame.com/get.php?platform=mac
```

The redirect `Location` header embeds the build:

```
https://airtame-app.b-cdn.net/app/latest/mac/Airtale-4.15.0.dmg
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://downloads-website.airtame.com/get.php?platform=mac`
- **latest_version:** `4.15.0` (parsed from the redirect `Location` header)

## Install / update / uninstall

- **install:** download the dmg, mount, copy the `.app` to `/Applications` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
