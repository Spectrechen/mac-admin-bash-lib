# Clipy Vendor Notes

## Vendor Information
- **Vendor:** Clipy Project (Open Source)
- **Product:** Clipy - Clipboard extension app for macOS
- **Website:** https://github.com/Clipy/Clipy
- **License:** Free/open-source software (GPLv3)
- **Installomator label:** clipy
- **Installer type:** dmg

## Download URLs
- **Download page:** https://github.com/Clipy/Clipy
- **Latest version:** 1.2.1 (confirmed via GitHub Releases)
- **GitHub Releases:** https://github.com/Clipy/Clipy/releases
- **App location:** /Applications/Clipy.app

## Version Detection
Version is fetched from GitHub Releases API (https://api.github.com/repos/Clipy/Clipy/releases/latest). Falls back to hardcoded version 1.2.1.

## Installation
- DMG download from GitHub Releases.
- Requires root privileges for /Applications install.
- Requires macOS 13 Ventura or later.
- Also available via Homebrew: `brew install --cask clipy`

## Update
No vendor-provided automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/Clipy.app
- ~/Library/Application Support/Clipy
- ~/Library/Preferences/org.clipy.plist
- ~/Library/Caches/org.clipy
- ~/Library/Saved Application State/org.clipy.savedState

## Sources
- https://github.com/Clipy/Clipy
- https://github.com/Clipy/Clipy/releases
- https://formulae.brew.sh/cask/clipy
