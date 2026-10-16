# San Francisco Arabic Font (applesfarabic)

## Vendor
Apple Inc.

## Source
- Apple Developer Fonts: https://developer.apple.com/fonts/
- San Francisco Arabic is an extension to the San Francisco typeface for Arabic script support.

## Installer Details
- **Label:** applesfarabic
- **Name:** San Francisco Arabic
- **Type:** pkgInDmg
- **DMG URL:** https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg
- **Package ID:** com.apple.pkg.SFArabicFonts
- **Team ID:** Software Update

## Versioning
No independent version API. Version is tied to macOS release.
- `latest_version()` returns the current macOS major version (e.g. "15.6")
- Fallback: "bundled"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls from CDN).
- **Uninstall:** Removes font directory and files from /Library/Fonts/ (San Francisco Arabic*).

## Notes
- Font installs to `/Library/Fonts/`
- Provides Arabic script support for the San Francisco typeface family.
- No standalone update mechanism; fonts are bundled with macOS updates.
