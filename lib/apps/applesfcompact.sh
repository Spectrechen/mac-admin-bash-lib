#!/usr/bin/env bash
# applesfcompact.sh - Apple San Francisco Compact Font helpers
#
# Vendor research:
#   San Francisco Compact is the variant of San Francisco optimized for
#   watchOS. Distributed by Apple from Developer CDN.
#   Source: https://developer.apple.com/fonts/
#   - DMG download URL:
#       https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg
#   - Package ID: com.apple.pkg.SanFranciscoCompact
#   - Team ID: Software Update
#   - No independent version API; version tied to macOS release.
#   - Installs fonts to /Library/Fonts/.

# Print the Apple Developer CDN URL for the San Francisco Compact font DMG.
maclib::apps::applesfcompact::suite_installer_url() {
  printf '%s\n' 'https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg'
}

# Print the latest version string. Tied to macOS version.
maclib::apps::applesfcompact::latest_version() {
  local macos_ver
  macos_ver=$(/usr/sbin/system_profiler SPSoftwareDataType 2>/dev/null | \
    grep 'System Version' | sed -E 's/.*: ([0-9]+\.[0-9]+).*/\1/')
  if [[ -n "$macos_ver" ]]; then
    printf '%s\n' "$macos_ver"
    return 0
  fi
  printf '%s\n' 'bundled'
  return 0
}

# Return 0 if San Francisco Compact font is installed.
maclib::apps::applesfcompact::is_installed() {
  [[ -d '/Library/Fonts/San Francisco Compact Font' ]] || \
  [[ -f '/Library/Fonts/SF Compact Rounded Regular.ttf' ]] || \
  return 1
  return 0
}

# Print the installed font path if present.
maclib::apps::applesfcompact::installed_path() {
  if [[ -d '/Library/Fonts/San Francisco Compact Font' ]]; then
    printf '%s\n' '/Library/Fonts/San Francisco Compact Font'
    return 0
  fi
  return 1
}

# Download and install the San Francisco Compact font DMG.
# Requires root (writes to /Library/Fonts).
maclib::apps::applesfcompact::install() {
  local url dmg_path tmp_dir
  url="$(maclib::apps::applesfcompact::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/SF-Compact.dmg"
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "applesfcompact::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "applesfcompact::install: failed to mount DMG"
    return 1
  fi

  local pkg_path
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "applesfcompact::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install.
maclib::apps::applesfcompact::update() {
  maclib::apps::applesfcompact::install "$@"
}

# Uninstall: remove font files.
maclib::apps::applesfcompact::uninstall() {
  rm -rf '/Library/Fonts/San Francisco Compact Font'
  for font in /Library/Fonts/SF\ Compact*; do
    [[ -f "$font" ]] && rm -f "$font"
  done
}
