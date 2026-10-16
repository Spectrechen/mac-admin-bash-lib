# ClipGrab Vendor Notes

## Vendor Information
- **Vendor:** libre media labs GmbH (Philipp Schmieder)
- **Product:** ClipGrab - Free video downloader and converter
- **Website:** https://clipgrab.org
- **License:** Free/open-source software (GPLv3)
- **Installomator label:** clipgrab
- **Installer type:** dmg

## Download URLs
- **Download page:** https://clipgrab.org
- **Latest version:** 4.0.0-beta2 (confirmed via clipgrab.org)
- **App location:** /Applications/ClipGrab.app

## Version Detection
No public API for version checking. The version is hardcoded as 4.0.0-beta2 based on the vendor's download page.

## Installation
- The vendor website provides a direct DMG download.
- Requires root privileges for /Applications install.
- Compatible with macOS 10.12 (Sierra) and newer, including Apple Silicon (M1+).

## Update
No vendor-provided automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/ClipGrab.app
- ~/Library/Application Support/ClipGrab
- ~/Library/Preferences/org.clipgrab.plist
- ~/Library/Caches/org.clipgrab

## Sources
- https://clipgrab.org
- https://clipgrab.de/update/en
- https://www.videohelp.com/software/ClipGrab
