# microsoftskypeforbusiness — vendor notes

- **Label (Installomator):** `microsoftskypeforbusiness`
- **App:** Skype for Business
- **Module:** `lib/communication/microsoftskypeforbusiness.sh` (`maclib::microsoftskypeforbusiness::*`)
- **Installer type:** pkg
- **Apple Developer Team ID:** `UBF8T346G9`

## Vendor source

Skype for Business ships a signed `.pkg` from the Microsoft fwlink:

```
https://go.microsoft.com/fwlink/?linkid=832978
```

The current build is parsed from the redirect `Location` header. Updates are
delivered through Microsoft Auto Update's `msupdate` tool (apps `MSFB16`).

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://go.microsoft.com/fwlink/?linkid=832978`
- **latest_version:** partial (`16.30.32.` — fwlink resolves to a versioned
  package name; the trailing dot is an artifact of the fwlink package name)

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** `msupdate --install --apps MSFB16` when the tool is present,
  otherwise re-run install.
- **uninstall:** no clean uninstall.
