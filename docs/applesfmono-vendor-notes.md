# San Francisco Mono Font (applesfmono)

## Vendor
Apple Inc.

## Source
- Apple Developer Fonts: https://developer.apple.com/fonts/
- San Francisco Mono is the monospaced variant of San Francisco, designed for coding environments like Xcode.
- Features six weights and supports Latin, Greek, and Cyrillic scripts.

## Installer Details
- **Label:** applesfmono
- **Name:** San Francisco Mono
- **Type:** pkgInDmg
- **DMG URL:** https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg
- **Package ID:** com.apple.pkg.SFMonoFonts
- **Team ID:** Software Update

## Versioning
No independent version API. Version is tied to macOS release.
- `latest_version()` returns the current macOS major version (e.g. "15.6")
- Fallback: "bundled"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls from CDN).
- **Uninstall:** Removes font directory and files from /Library/Fonts/ (San Francisco Mono*, SFMono*).

## Notes
- Font installs to `/Library/Fonts/`
- Used for coding environments and monospaced text rendering.
- No standalone update mechanism; fonts are bundled with macOS updates.
