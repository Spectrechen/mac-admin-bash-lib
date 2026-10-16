#!/usr/bin/env bash
# applesfsymbols.sh - Apple SF Symbols helpers
#
# Vendor research:
#   SF Symbols is a library of over 7,000 symbols designed to integrate
#   seamlessly with San Francisco font. Distributed by Apple.
#   Source: https://developer.apple.com/sf-symbols/
#   - DMG download URL is extracted from the SF Symbols page:
#       curl -fs "https://developer.apple.com/sf-symbols/" | grep -oe "https.*Symbols.*\.dmg"
#   - Package ID: com.apple.pkg.SFSymbols (inferred)
#   - Team ID: Software Update
#   - Version is extracted from the DMG filename (e.g. SF-Symbols-5.3.dmg -> 5.3)
#   - Installs fonts to /Library/Fonts/.

# Print the Apple Developer CDN URL for the SF Symbols DMG.
# Extracts the download link from the SF Symbols page.
maclib::apps::applesfsymbols::suite_installer_url() {
  local url
  url=$(curl -fs "https://developer.apple.com/sf-symbols/" 2>/dev/null | \
    grep -oe 'https[^"]*Symbols[^"]*\.dmg' | head -1)
  if [[ -n "$url" ]]; then
    printf '%s\n' "$url"
    return 0
  fi
  # Fallback: known CDN pattern
  printf '%s\n' 'https://devimages-cdn.apple.com/sf-symbols/download/SF-Symbols.dmg'
  return 0
}

# Print the latest SF Symbols version. Extracted from DMG URL or known latest.
maclib::apps::applesfsymbols::latest_version() {
  local url ver
  url="$(maclib::apps::applesfsymbols::suite_installer_url)"
  # Extract version from URL: SF-Symbols-5.3.dmg -> 5.3
  ver=$(echo "$url" | grep -oE '[0-9]+\.[0-9]+' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback: known latest version (check for update)
  printf '%s\n' '6.0'
  return 0
}

# Return 0 if SF Symbols font is installed.
maclib::apps::applesfsymbols::is_installed() {
  [[ -d '/Library/Fonts/SF Symbols' ]] || \
  [[ -f '/Library/Fonts/SFSymbolsRegular.otf' ]] || \
  return 1
  return 0
}

# Print the installed font path if present.
maclib::apps::applesfsymbols::installed_path() {
  if [[ -d '/Library/Fonts/SF Symbols' ]]; then
    printf '%s\n' '/Library/Fonts/SF Symbols'
    return 0
  fi
  return 1
}

# Download and install SF Symbols DMG.
# Requires root (writes to /Library/Fonts).
maclib::apps::applesfsymbols::install() {
  local url dmg_path tmp_dir
  url="$(maclib::apps::applesfsymbols::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/SF-Symbols.dmg"
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "applesfsymbols::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "applesfsymbols::install: failed to mount DMG"
    return 1
  fi

  local pkg_path
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "applesfsymbols::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install.
maclib::apps::applesfsymbols::update() {
  maclib::apps::applesfsymbols::install "$@"
}

# Uninstall: remove font files.
maclib::apps::applesfsymbols::uninstall() {
  rm -rf '/Library/Fonts/SF Symbols'
  for font in /Library/Fonts/SFSymbols*; do
    [[ -f "$font" ]] && rm -f "$font"
  done
}
