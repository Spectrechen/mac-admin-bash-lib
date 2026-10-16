# microsoftteamsnew — vendor notes

- **Label (Installomator):** `microsoftteamsnew`
- **App:** Microsoft Teams (new)
- **Module:** `lib/communication/microsoftteamsnew.sh` (`maclib::microsoftteamsnew::*`)
- **Installer type:** pkg (package ID `com.microsoft.teams2`)
- **Apple Developer Team ID:** `UBF8T346G9`

## Vendor source

Microsoft Teams (new) ships a signed `.pkg` whose location is resolved from a
Microsoft Auto Update XML manifest (Application ID `TEAMS21`):

```
https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/0409TEAMS21.xml
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://teamsinstaller.public.onecdn.static.microsoft/production-osx/26213.1006.5011.1671/MicrosoftTeams.pkg`
- **latest_version:** `26213.1006.5011.1671`

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** `msupdate --install --apps TEAMS21` when the tool is present,
  otherwise re-run install.
- **uninstall:** no clean uninstall.
