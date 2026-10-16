# SF Symbols (applesfsymbols)

## Vendor
Apple Inc.

## Source
- Apple Developer SF Symbols: https://developer.apple.com/sf-symbols/
- SF Symbols is a library of over 7,000 symbols designed to integrate seamlessly with San Francisco font.
- Requires macOS 10.10.5 or later.

## Installer Details
- **Label:** applesfsymbols (also sfsymbols)
- **Name:** SF Symbols
- **Type:** pkgInDmg
- **DMG URL:** Dynamically extracted from the SF Symbols page:
  `curl -fs "https://developer.apple.com/sf-symbols/" | grep -oe "https.*Symbols.*\.dmg" | head -1`
- **Package ID:** com.apple.pkg.SFSymbols (inferred)
- **Team ID:** Software Update
- **Latest known version:** 6.0

## Versioning
- `latest_version()` extracts version from DMG URL (e.g. "SF-Symbols-5.3.dmg" -> "5.3")
- Falls back to "6.0" if URL parsing fails

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple Developer CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls latest from CDN).
- **Uninstall:** Removes font directory and files from /Library/Fonts/ (SF Symbols*, SFSymbols*).

## Notes
- Font installs to `/Library/Fonts/`
- Used for macOS app iconography and UI symbol rendering.
- Version extracted from DMG filename pattern.
- No standalone update mechanism; symbols are bundled with macOS updates.
