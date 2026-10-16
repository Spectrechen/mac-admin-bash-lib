# ClickShare Vendor Notes

## Vendor Information
- **Vendor:** Barco
- **Product:** ClickShare Desktop App - Wireless meeting room collaboration
- **Website:** https://www.barco.com/en/support/software/R3306192
- **License:** Free to download and use
- **Installomator label:** clickshare
- **Installer type:** zip

## Download URLs
- **Download page:** https://www.barco.com/en/support/software/R3306192
- **Latest version:** N/A (no versioned releases documented publicly)
- **App location:** /Applications/ClickShare.app

## Version Detection
No versioned releases documented for ClickShare Desktop App. The app is free and updated silently via the vendor website. Returns "latest" as the version string.

## Installation
- The vendor website provides a ZIP download containing the app bundle.
- Requires root privileges for /Applications install.
- Designed for use with Barco ClickShare Present and ClickShare Conference devices.
- Also available as PKG for mass deployment via Intune (see Barco KB article).

## Update
No vendor-provided automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/ClickShare.app
- ~/Library/Application Support/ClickShare
- ~/Library/Preferences/com.barco.clickshare.plist
- ~/Library/Caches/com.barco.clickshare

## Sources
- https://www.barco.com/en/support/software/R3306192
- https://www.barco.com/en/support/knowledge-base/13167-clickshare-desktop-app-pkg-installer-mass-deployment-on-macos
- https://www.barco.com/en/product/clickshare-app
