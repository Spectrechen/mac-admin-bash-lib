# ProVideoFormats (appleprovideoformats)

## Vendor
Apple Inc.

## Source
- Apple Support Page: https://support.apple.com/en-us/106396
- ProVideoFormats extends QuickTime and Pro apps with additional video codecs.

## Installer Details
- **Label:** appleprovideoformats
- **Name:** ProVideoFormats
- **Type:** pkgInDmg
- **Download URL:** Dynamically resolved from Apple Support page:
  `curl -s "https://support.apple.com/en-us/106396" | grep -Eo 'https://updates\.cdn-apple\.com[^\"]+ProVideoFormats\.dmg'`
- **Package ID:** com.apple.pkg.ProVideoFormats
- **Team ID:** Software Update
- **Latest known version:** 3.1

## Versioning
- `latest_version()` checks installed version via `pkgutil --pkg-info`
- Fallback: "3.1"

## Install/Update/Uninstall
- **Install:** Downloads DMG from Apple CDN, mounts it, installs the .pkg via `installer`. Requires root.
- **Update:** Same as install (pulls latest from CDN).
- **Uninstall:** Removes codec plugin files from `/Library/QuickTime/` and forgets the package.

## Notes
- Codec package for professional video applications (Final Cut Pro, QuickTime, etc.)
- Required for ProRes RAW and other professional video formats.
- Dynamic download URL means the actual CDN link changes between versions.
