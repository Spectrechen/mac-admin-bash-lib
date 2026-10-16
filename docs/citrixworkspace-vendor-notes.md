# Citrix Workspace Vendor Notes

## Vendor Information
- **Vendor:** Citrix (now part of Blue Prism / Perforce)
- **Product:** Citrix Workspace app for Mac - Remote app and desktop access
- **Website:** https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html
- **License:** Free to download
- **Installomator label:** citrixworkspace
- **Installer type:** pkg

## Download URLs
- **Download page:** https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html
- **Latest version:** 2607 (July 2026, confirmed via citrix.com/downloads)
- **App location:** /Applications/Citrix Workspace.app

## Version Detection
Citrix uses a date-based versioning scheme (YYMM). The version is hardcoded as 2607 based on the vendor's download page. No public API for version checking.

## Installation
- The vendor website provides a direct PKG download.
- Requires root privileges for /Applications install.
- Enterprise deployment supported via PKG installer and MDM profiles.

## Update
Citrix Workspace app has a built-in Auto Update feature. The app checks for updates automatically and can be triggered manually via the app menu.

## Uninstall
Remove app bundle and associated support files:
- /Applications/Citrix Workspace.app
- ~/Library/Application Support/Citrix
- ~/Library/Preferences/com.citrix.*.plist
- ~/Library/LaunchAgents/com.citrix.*.plist
- /Library/Application Support/Citrix

## Sources
- https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html
- https://docs.citrix.com/en-us/citrix-workspace-app-for-mac.html
- https://docs.citrix.com/en-us/citrix-workspace-app-for-mac/install-uninstall.html
