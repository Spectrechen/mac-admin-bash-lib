# AquaSKK (aquaskk)

## Vendor
codefirst (Tadayuki Onishi / @kenchan0130)

## Source
- GitHub: https://github.com/codefirst/aquaskk
- Homebrew Cask: https://formulae.brew.sh/cask/aquaskk
- Official Site: https://softantenna.com/softwares/5377-aquaskk
- AquaSKK is a Japanese input method (SKK-compatible) without morphological analysis.

## Installer Details
- **Label:** aquaskk
- **Name:** aquaskk
- **Type:** pkg
- **Installer URL:** https://github.com/codefirst/aquaskk/releases/latest/download/aquaskk.pkg
- **Package ID:** org.codefirst.aquaskk.pkg
- **Team ID:** FPZK4WRGW7
- **App Location:** /Applications/AquaSKK.app
- **Input Method:** Library/Input Methods/AquaSKK.inputmethod
- **Latest known version:** 4.7.6 (built with Xcode 16.0 / macOS Sequoia 15.0)

## Versioning
- `latest_version()` queries GitHub Releases API for the latest tag
- Fallback: "4.7.6"

## Install/Update/Uninstall
- **Install:** Downloads the PKG from GitHub Releases, installs via `installer`. Requires root.
- **Update:** Same as install (reinstalls latest from GitHub).
- **Uninstall:** Removes app bundle, input method, and forgets the package via `pkgutil --forget`.
  - Credit: https://scrapbox.io/upamune/AquaSKKをアンインストールする

## Notes
- PKG installs to `/Applications/AquaSKK.app` and `/Library/Input Methods/AquaSKK.inputmethod`
- May require logout/login to start the new input method process.
- Can be installed via Homebrew: `brew install --cask aquaskk`
- Open source under the terms of the GitHub repository.
