# San Francisco Compact Font (applesfcompact)

## Vendor
Apple Inc.

## Source
- Apple Developer Fonts: https://developer.apple.com/fonts/
- San Francisco Compact is the variant of San Francisco optimized for watchOS.
- Includes a rounded variant for small-screen readability.

## Installer Details
- **Label:** applesfcompact
- **Name:** San Francisco Compact
- **Type:** pkgInDmg
- **DMG URL:** https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg
- **Package ID:** com.apple.pkg.SanFranciscoCompact
- **Team ID:** Software Update

## Versioning
No independent version API. Version is tied to macOS release.
- `latest_version()` returns the current macOS major version (e.g. "15.6")
- Fallback: "bundled"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls from CDN).
- **Uninstall:** Removes font directory and files from /Library/Fonts/ (San Francisco Compact*, SF Compact*).

## Notes
- Font installs to `/Library/Fonts/`
- Used primarily for watchOS development and cross-platform font consistency.
- No standalone update mechanism; fonts are bundled with macOS updates.
