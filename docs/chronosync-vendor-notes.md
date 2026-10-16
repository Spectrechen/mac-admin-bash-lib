# ChronoSync Vendor Notes

## Vendor Information
- **Vendor:** Econ Technologies, Inc.
- **Product:** ChronoSync - Backup and file synchronization for macOS
- **Website:** https://www.econtechnologies.com/chronosync/overview.html
- **License:** Commercial (free trial available, lifetime license purchasable)
- **Installomator label:** chronosync
- **Installer type:** pkgInDmg

## Download URLs
- **Download page:** https://www.econtechnologies.com/chronosync/overview.html
- **Latest version:** 12.0.2 (confirmed via econtechnologies.com)
- **App location:** /Applications/Chronosync.app

## Version Detection
No public API for version checking. The version is hardcoded as 12.0.2 based on the vendor's download page.

## Installation
- The vendor website provides a DMG download containing a PKG installer.
- Requires root privileges for /Applications install.
- Post-install activation requires a license key (trial or purchased).

## Update
No automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/Chronosync.app
- ~/Library/Application Support/Chronosync
- ~/Library/Preferences/com.econtechnologies.Chronosync.plist
- ~/Library/Caches/com.econtechnologies.Chronosync

## Sources
- https://www.econtechnologies.com/chronosync/overview.html
- https://mac.softpedia.com/get/Utilities/ChronoSync.shtml
- https://chronosync.macupdate.com/
