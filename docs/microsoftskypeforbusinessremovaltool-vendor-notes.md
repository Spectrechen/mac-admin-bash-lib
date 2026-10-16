# microsoftskypeforbusinessremovaltool — vendor notes

- **Label (Installomator):** `microsoftskypeforbusinessremovaltool`
- **App:** Skype for Business Removal Tool
- **Module:** `lib/communication/microsoftskypeforbusinessremovaltool.sh` (`maclib::microsoftskypeforbusinessremovaltool::*`)
- **Installer type:** pkg (removal tool, package ID `com.microsoft.remove.SkypeForBusiness`)
- **Apple Developer Team ID:** `QGS93ZLCU7`

## Vendor source

This is a removal tool served from office-reset.com. The installer URL is
assembled from the current file listed on:

```
https://office-reset.com/macadmins/
```

## Concrete values (2026-08-25)

- **suite_installer_url:** `https://office-reset.com/download/Microsoft_SkypeForBusiness_Removal_1.9.1.pkg`
- **latest_version:** none meaningful (removal tool; no version string)

## Install / update / uninstall

- **install:** download `.pkg`, install with `/usr/sbin/installer` (root).
- **update:** re-run install (one-shot removal tool).
- **uninstall:** the tool performs the uninstall itself (see install()).
