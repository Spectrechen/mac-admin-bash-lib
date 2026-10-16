# ClickUp Vendor Notes

## Vendor Information
- **Vendor:** ClickUp Inc.
- **Product:** ClickUp Desktop - All-in-one project management and productivity app
- **Website:** https://clickup.com/download
- **License:** Free to download and use
- **Installomator label:** clickup
- **Installer type:** dmg

## Download URLs
- **Download page:** https://clickup.com/download
- **Latest version:** N/A (auto-updates via built-in updater)
- **App location:** /Applications/ClickUp.app

## Version Detection
No public version API for ClickUp Desktop. The app auto-updates via its built-in updater (File > ClickUp > Check for updates). Returns "latest" as the version string.

## Installation
- The vendor website provides a direct DMG download.
- Requires root privileges for /Applications install.
- Available for Apple Silicon and Intel Macs.

## Update
ClickUp Desktop has a built-in auto-update mechanism. The app checks for updates automatically and can be triggered manually via the app menu (File > ClickUp > Check for updates).

## Uninstall
Remove app bundle and associated support files:
- /Applications/ClickUp.app
- ~/Library/Application Support/ClickUp
- ~/Library/Preferences/com.clickup.clickup.plist
- ~/Library/Caches/com.clickup.clickup
- ~/Library/Saved Application State/com.clickup.clickup.savedState

## Sources
- https://clickup.com/download
- https://help.clickup.com/hc/en-us/articles/6311884486423-Use-the-ClickUp-desktop-app
