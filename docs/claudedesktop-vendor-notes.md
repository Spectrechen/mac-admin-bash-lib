# Claude Desktop Vendor Notes

## Vendor Information
- **Vendor:** Anthropic PBC
- **Product:** Claude Desktop - AI assistant desktop app
- **Website:** https://claude.ai/download
- **License:** Free to download and use (requires Anthropic account)
- **Installomator label:** claudedesktop
- **Installer type:** zip

## Download URLs
- **Download page:** https://claude.ai/download
- **Latest version:** 2.15.0 (confirmed via GitHub Releases and claude.ai/download)
- **GitHub Releases:** https://github.com/anthropics/claude-desktop/releases
- **App location:** /Applications/Claude.app

## Version Detection
Version is fetched from GitHub Releases API (https://api.github.com/repos/anthropics/claude-desktop/releases/latest). Falls back to hardcoded version 2.15.0.

## Installation
- The vendor website provides a direct ZIP download containing the app bundle.
- Requires root privileges for /Applications install.
- Requires an Anthropic account for activation.

## Update
No vendor-provided automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/Claude.app
- ~/Library/Application Support/Claude
- ~/Library/Preferences/com.anthropic.claude.plist
- ~/Library/Caches/com.anthropic.claude
- ~/Library/Saved Application State/com.anthropic.claude.savedState

## Sources
- https://claude.ai/download
- https://github.com/anthropics/claude-desktop/releases
