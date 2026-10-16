# Vendor Notes: IBM Aspera Connect (aspera)

## Installomator Label
- **label**: aspera
- **name**: None (no name set in Installomator inventory)
- **type**: None (no type set in Installomator inventory)

## Vendor Information
- **Vendor**: IBM
- **Product**: IBM Aspera Connect (browser plugin for FASP high-speed transfers)
- **Website**: https://ibmaspera.com/
- **Download**: https://ibmaspera.com/help/downloads/desktop
- **Downloads**: https://download.asperasoft.com/download/dist/aspera-connect/

## Installer Details
- **Installer URL**: https://download.asperasoft.com/download/dist/aspera-connect/
- **Installer Type**: None (browser plugin, not a standalone app)
- **Apple Developer Team ID**: n/a (IBM — verify against vendor)
- **Latest Version**: 3.11.2 (as of 2026-08-29, per brew cask and IBM docs)

## Update Path
No documented automatic update path. Re-run install to update.

## Uninstall
Aspera Connect can be removed by deleting the plugin directory:
- /Library/Internet Plug-Ins/Aspera Connect.plugin
- ~/Library/Internet Plug-Ins/Aspera Connect.plugin
- /Applications/Aspera Connect.app

## Notes
- The "aspera" label in Installomator has no name or type set.
- The related "asperaconnect" label uses a proper DMG/pkg installer.
- Aspera Connect is a browser plugin that enables FASP high-speed transfers.
- For enterprise deployment, use "asperaconnect" label instead which has a proper DMG installer.
- This "aspera" entry is a placeholder for the label that has no installer metadata in Installomator.

## Sources
- https://ibmaspera.com/help/downloads/desktop
- https://download.asperasoft.com/download/docs/connect/3.8.3/user_osx/webhelp/dita/installation.html
- https://formulae.brew.sh/cask/ibm-aspera-connect
