# Cisdem Document Reader Vendor Notes

## Vendor Information
- **Vendor:** Cisdem Inc.
- **Product:** Cisdem Document Reader - Multi-format document viewer (PDF, DXF, Visio, XPS, DjVu, etc.)
- **Website:** https://www.cisdem.com/document-reader.html
- **License:** Commercial (free to download, paid for full features)
- **Installomator label:** cisdemdocumentreader
- **Installer type:** dmg

## Download URLs
- **Download page:** https://www.cisdem.com/document-reader.html
- **Latest version:** 5.5.1 (confirmed via Homebrew cask formulae.brew.sh/cask/cisdem-document-reader)
- **App location:** /Applications/Cisdem-Documentreader.app

## Version Detection
No public API for version checking. The version is hardcoded as 5.5.1 based on Homebrew cask.

## Installation
- The vendor website provides a direct DMG download.
- Requires root privileges for /Applications install.
- Also available via Homebrew: `brew install --cask cisdem-document-reader`

## Update
No automatic update mechanism. Reinstall the latest version to update.

## Uninstall
Remove app bundle and associated support files:
- /Applications/Cisdem-Documentreader.app
- ~/Library/Application Support/Cisdem/Documentreader
- ~/Library/Preferences/com.cisdem.Documentreader.plist
- ~/Library/Caches/com.cisdem.Documentreader

## Sources
- https://www.cisdem.com/document-reader.html
- https://formulae.brew.sh/cask/cisdem-document-reader
- https://www.majorgeeks.com/files/details/cisdem_document_reader.html
