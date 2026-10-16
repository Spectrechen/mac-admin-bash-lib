# microsoftteamsreset — vendor notes

- **Label (Installomator):** `microsoftteamsreset`
- **App:** Microsoft Teams Reset Tool
- **Module:** `lib/communication/microsoftteamsreset.sh` (`maclib::microsoftteamsreset::*`)
- **Installer type:** pkg (removal/reset tool, package ID `com.microsoft.reset.Teams`)
- **Apple Developer Team ID:** `QGS93ZLCU7`

## Vendor source

This is a reset tool served from office-reset.com. The installer URL is
assembled from the current file listed on:

```
https://office-reset.com/macadmins/
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://office-reset.com/download/Microsoft_Teams_Reset_1.9.1.pkg`
- **latest_version:** none meaningful (reset tool; no version string)

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** re-run install (one-shot reset tool).
- **uninstall:** the tool performs the reset itself (see install()).
