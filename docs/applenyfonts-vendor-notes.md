# Apple New York Font (applenyfonts)

## Vendor
Apple Inc.

## Source
- Apple Developer Fonts: https://developer.apple.com/fonts/
- New York is a serif typeface based on historical type styles, with variable optical sizes.
- WWDC 2022 introduced New York as part of the Apple font family.

## Installer Details
- **Label:** applenyfonts
- **Name:** Apple New York Font Collection
- **Type:** pkgInDmg
- **DMG URL:** https://devimages-cdn.apple.com/design/resources/download/NY.dmg
- **Package ID:** com.apple.pkg.NYFonts
- **Team ID:** Software Update

## Versioning
No independent version API. Version is tied to macOS release.
- `latest_version()` returns the current macOS major version (e.g. "15.6")
- Fallback: "bundled"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls from CDN).
- **Uninstall:** Removes font files from /Library/Fonts/ (New York*.ttf, New York*.otf).

## Notes
- Font installs to `/Library/Fonts/`
- No standalone update mechanism; fonts are bundled with macOS updates.
- For MDM deployment, the DMG can be downloaded and staged.
