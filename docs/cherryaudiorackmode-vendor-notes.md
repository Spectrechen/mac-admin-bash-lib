# Vendor Notes: Rackmode Signal Processors (cherryaudiorackmode)

## Overview
Rackmode Signal Processors is a virtual instrument/effect/plugin from Cherry Audio (except ChronoAgent from Econ Technologies).

## Vendor Sources

- Product page: https://cherryaudio.com/products/rackmode
- Store page: https://store.cherryaudio.com/software/rackmode-macos-installer
- Version history: https://cherryaudio.com/products/rackmode/version-history
- Direct installer: https://store.cherryaudio.com/downloads/rackmode-macos-installer?file=Rackmode-Installer-macOS.pkg

## Package Information

- Package ID: `com.cherryaudio.pkg.RackmodePackage-StandAlone`
- Team ID: `A2XFV22B2X`
- Installer type: `pkg`

## Install/Update/Uninstall

- Install: Download DMG from installer URL, mount, copy .app to /Applications/ (or use pkgutil for pkg installers)
- Update: No vendor-provided update API or endpoint. Updates must be performed by downloading the latest installer from the store page and running install().
- Uninstall: Remove package receipt `com.cherryaudio.pkg.RackmodePackage-StandAlone` via `pkgutil --forget`

## Notes

- All Cherry Audio products require a free Cherry Audio account for download.
- Installers are macOS pkg or dmg format.
- Products are available in AU, VST, VST3, AAX, and standalone formats.
- macOS 10.13+ required for most products.

## Sources

- Installomator label: `cherryaudiorackmode`
- Cherry Audio: https://cherryaudio.com

