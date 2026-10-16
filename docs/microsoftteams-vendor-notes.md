# microsoftteams — vendor notes

- **Label (Installomator):** `microsoftteamsclassic|microsoftteams`
- **App:** Microsoft Teams classic
- **Module:** `lib/communication/microsoftteams.sh` (`maclib::microsoftteams::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `UBF8T346G9`

## Vendor source

Microsoft Teams classic ships a signed `.pkg` from the Microsoft fwlink:

```
https://go.microsoft.com/fwlink/?linkid=869428
```

The fwlink resolves to a fixed `lkg` URL
(`https://statics.teams.cdn.office.net/production-osx/enterprise/webview2/lkg/MicrosoftTeams.pkg`)
with no embedded version number.

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://go.microsoft.com/fwlink/?linkid=869428`
- **latest_version:** none — the fwlink resolves to a fixed `lkg` URL with no
  version string (honest empty).

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** `msupdate --install --apps TEAMS10` when the tool is present,
  otherwise re-run install.
- **uninstall:** no clean uninstall.
