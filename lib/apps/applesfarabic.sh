#!/usr/bin/env bash
# applesfarabic.sh - Apple San Francisco Arabic Font helpers
#
# Vendor research:
#   San Francisco Arabic is a font extension for the San Francisco typeface,
#   distributed by Apple for Arabic script support.
#   Source: https://developer.apple.com/fonts/
#   - DMG download URL:
#       https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg
#   - Package ID: com.apple.pkg.SFArabicFonts
#   - Team ID: Software Update
#   - No independent version API; version tied to macOS release.
#   - Installs fonts to /Library/Fonts/.

# Print the Apple Developer CDN URL for the San Francisco Arabic font DMG.
maclib::apps::applesfarabic::suite_installer_url() {
  printf '%s\n' 'https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg'
}

# Print the latest version string. Tied to macOS version.
maclib::apps::applesfarabic::latest_version() {
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

# Return 0 if San Francisco Arabic font is installed.
maclib::apps::applesfarabic::is_installed() {
  [[ -d '/Library/Fonts/San Francisco Arabic Font' ]] || \
  [[ -f '/Library/Fonts/San Francisco Arabic Regular.ttf' ]] || \
  return 1
  return 0
}

# Print the installed font path if present.
maclib::apps::applesfarabic::installed_path() {
  if [[ -d '/Library/Fonts/San Francisco Arabic Font' ]]; then
    printf '%s\n' '/Library/Fonts/San Francisco Arabic Font'
    return 0
  fi
  return 1
}

# Download and install the San Francisco Arabic font DMG.
# Requires root (writes to /Library/Fonts).
maclib::apps::applesfarabic::install() {
  local url dmg_path tmp_dir
  url="$(maclib::apps::applesfarabic::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/SF-Arabic.dmg"
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "applesfarabic::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "applesfarabic::install: failed to mount DMG"
    return 1
  fi

  local pkg_path
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "applesfarabic::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install.
maclib::apps::applesfarabic::update() {
  maclib::apps::applesfarabic::install "$@"
}

# Uninstall: remove font files.
maclib::apps::applesfarabic::uninstall() {
  rm -rf '/Library/Fonts/San Francisco Arabic Font'
  for font in /Library/Fonts/San\ Francisco\ Arabic*; do
    [[ -f "$font" ]] && rm -f "$font"
  done
}
