#!/usr/bin/env bash
# applesfpro.sh - Apple San Francisco Pro Font helpers
#
# Vendor research:
#   San Francisco Pro is the sans-serif system font for iOS, macOS, tvOS.
#   Distributed by Apple from Developer CDN.
#   Source: https://developer.apple.com/fonts/
#   - DMG download URL:
#       https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg
#   - Package ID: com.apple.pkg.SanFranciscoPro
#   - Team ID: Software Update
#   - No independent version API; version tied to macOS release.
#   - Installs fonts to /Library/Fonts/.

# Print the Apple Developer CDN URL for the San Francisco Pro font DMG.
maclib::apps::applesfpro::suite_installer_url() {
  printf '%s\n' 'https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg'
}

# Print the latest version string. Tied to macOS version.
maclib::apps::applesfpro::latest_version() {
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

# Return 0 if San Francisco Pro font is installed.
maclib::apps::applesfpro::is_installed() {
  [[ -d '/Library/Fonts/San Francisco Pro Font' ]] || \
  [[ -f '/Library/Fonts/SF-Pro-Regular.otf' ]] || \
  return 1
  return 0
}

# Print the installed font path if present.
maclib::apps::applesfpro::installed_path() {
  if [[ -d '/Library/Fonts/San Francisco Pro Font' ]]; then
    printf '%s\n' '/Library/Fonts/San Francisco Pro Font'
    return 0
  fi
  return 1
}

# Download and install the San Francisco Pro font DMG.
# Requires root (writes to /Library/Fonts).
maclib::apps::applesfpro::install() {
  local url dmg_path tmp_dir
  url="$(maclib::apps::applesfpro::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/SF-Pro.dmg"
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "applesfpro::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "applesfpro::install: failed to mount DMG"
    return 1
  fi

  local pkg_path
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "applesfpro::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install.
maclib::apps::applesfpro::update() {
  maclib::apps::applesfpro::install "$@"
}

# Uninstall: remove font files.
maclib::apps::applesfpro::uninstall() {
  rm -rf '/Library/Fonts/San Francisco Pro Font'
  for font in /Library/Fonts/SF-Pro*; do
    [[ -f "$font" ]] && rm -f "$font"
  done
}
