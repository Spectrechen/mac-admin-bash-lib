# airtamepkg — vendor notes

- **Label (Installomator):** `airtamepkg`
- **App:** Airtale
- **Module:** `lib/communication/airtamepkg.sh` (`maclib::communication::airtamepkg::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `4TPSP88HN2`

## Vendor source

Airtale serves the current build through a redirect endpoint (Installomator
`airtamepkg` label):

```
https://downloads-website.airtame.com/get.php?platform=mac&pkg=true
```

The redirect `Location` header embeds the build:

```
https://airtame-app.b-cdn.net/app/latest/mac/Airtale-4.15.0.pkg
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://downloads-website.airtame.com/get.php?platform=mac&pkg=true`
- **latest_version:** `4.15.0` (parsed from the redirect `Location` header)

## Install / update / uninstall

- **install:** download the pkg and install with `/usr/sbin/installer` (root).
- **update:** re-run install (no separate updater tool).
- **uninstall:** no clean uninstall.
