# Vendor Notes: Sync (cherryaudiosync)

## Overview
Sync is a virtual instrument/effect/plugin from Cherry Audio (except ChronoAgent from Econ Technologies).

## Vendor Sources

- Product page: https://cherryaudio.com/products/sync
- Store page: https://store.cherryaudio.com/software/sync-macos-installer
- Version history: https://cherryaudio.com/products/sync/version-history
- Direct installer: https://store.cherryaudio.com/downloads/sync-macos-installer?file=Sync-Installer-macOS.pkg

## Package Information

- Package ID: `com.cherryaudio.pkg.SyncPackage`
- Team ID: `A2XFV22B2X`
- Installer type: `pkg`

## Install/Update/Uninstall

- Install: Download DMG from installer URL, mount, copy .app to /Applications/ (or use pkgutil for pkg installers)
- Update: Updates available via store page download; install() fetches latest.
- Uninstall: Remove package receipt `com.cherryaudio.pkg.SyncPackage` via `pkgutil --forget`

## Notes

- All Cherry Audio products require a free Cherry Audio account for download.
- Installers are macOS pkg or dmg format.
- Products are available in AU, VST, VST3, AAX, and standalone formats.
- macOS 10.13+ required for most products.

## Sources

- Installomator label: `cherryaudiosync`
- Cherry Audio: https://cherryaudio.com

