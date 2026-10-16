# Aquamacs Emacs (aquamacs)

## Vendor
The Aquamacs Project

## Source
- Official Site: https://aquamacs.org/
- Downloads: https://aquamacs.org/downloads/
- Aquamacs is the Emacs distribution for macOS, based on GNU Emacs.

## Installer Details
- **Label:** aquamacs
- **Name:** Aquamacs
- **Type:** dmg
- **Installer URL:** https://aquamacs.org/downloads/
- **DMG Download URL Pattern:**
  `https://aquamacs.org/file_download/aquamacs-emacs-<version>.dmg`
- **Team ID:** DTBC5BX3L9
- **App Location:** /Applications/Aquamacs Emacs.app
- **Latest stable version:** 3.6 (Mac OS 10.11+ El Capitan or later)
- **Alpha version:** 4 (based on Emacs 29.4, universal binary for Apple Silicon and Intel)

## Versioning
- `latest_version()` scrapes the downloads page for "Aquamacs Emacs X.Y" pattern
- Fallback: "3.6"

## Install/Update/Uninstall
- **Install:** Downloads DMG from aquamacs.org, mounts it, copies the app bundle to /Applications. Requires root.
- **Update:** Same as install (reinstalls latest from DMG).
- **Uninstall:** Removes app bundle and preferences from ~/Library/Preferences/, ~/Library/Caches/, and ~/Library/Saved Application State/.

## Notes
- App installs to `/Applications/Aquamacs Emacs.app`
- Emacs 29.4-based alpha 4 is available for newer macOS versions.
- Universal binary supports both Apple Silicon (M-series) and Intel CPUs.
- Preferences stored in `org.gnu.Aquamacs*` bundle identifiers.
