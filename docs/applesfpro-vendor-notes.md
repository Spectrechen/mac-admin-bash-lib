# San Francisco Pro Font (applesfpro)

## Vendor
Apple Inc.

## Source
- Apple Developer Fonts: https://developer.apple.com/fonts/
- San Francisco Pro is the sans-serif system font for iOS, macOS, and tvOS.
- Optimized for high legibility across various text sizes and screen resolutions.

## Installer Details
- **Label:** applesfpro
- **Name:** San Francisco Pro
- **Type:** pkgInDmg
- **DMG URL:** https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg
- **Package ID:** com.apple.pkg.SanFranciscoPro
- **Team ID:** Software Update

## Versioning
No independent version API. Version is tied to macOS release.
- `latest_version()` returns the current macOS major version (e.g. "15.6")
- Fallback: "bundled"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls from CDN).
- **Uninstall:** Removes font directory and files from /Library/Fonts/ (San Francisco Pro*, SF-Pro*).

## Notes
- Font installs to `/Library/Fonts/`
- The primary system font for Apple platforms.
- No standalone update mechanism; fonts are bundled with macOS updates.
