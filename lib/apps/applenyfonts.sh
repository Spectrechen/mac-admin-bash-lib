#!/usr/bin/env bash
# applenyfonts.sh - Apple New York Font helpers
#
# Vendor research:
#   The New York font family is distributed by Apple as part of macOS.
#   It is available from Apple Developer CDN but has no standalone installer.
#   Fonts are bundled with macOS and installed via system updates.
#   Source: https://developer.apple.com/fonts/
#   - DMG download URL:
#       https://devimages-cdn.apple.com/design/resources/download/NY.dmg
#   - Package ID: com.apple.pkg.NYFonts
#   - Team ID: Software Update
#   - No independent version API; version tied to macOS release.
#   - Fonts install to /Library/Fonts/ when the DMG is mounted and pkg installed.

# Print the Apple Developer CDN URL for the New York font DMG.
maclib::apps::applenyfonts::suite_installer_url() {
  printf '%s\n' 'https://devimages-cdn.apple.com/design/resources/download/NY.dmg'
}

# Print the latest version string.
# New York font version is tied to macOS; returns the macOS major version.
maclib::apps::applenyfonts::latest_version() {
  local macos_ver
  macos_ver=$(/usr/sbin/system_profiler SPSoftwareDataType 2>/dev/null | \
    grep 'System Version' | sed -E 's/.*: ([0-9]+\.[0-9]+).*/\1/')
  if [[ -n "$macos_ver" ]]; then
    printf '%s\n' "$macos_ver"
    return 0
  fi
  # Fallback: return bundled marker
  printf '%s\n' 'bundled'
  return 0
}

# Return 0 if the New York font is installed.
maclib::apps::applenyfonts::is_installed() {
  [[ -f '/Library/Fonts/New York Regular.ttf' ]] || \
  [[ -f '/Library/Fonts/New York Regular Italic.ttf' ]] || \
  return 1
  return 0
}

# Print the installed font path if present (empty otherwise).
maclib::apps::applenyfonts::installed_path() {
  if [[ -f '/Library/Fonts/New York Regular.ttf' ]]; then
    printf '%s\n' '/Library/Fonts/New York Regular.ttf'
    return 0
  fi
  return 1
}

# Download and install the New York font DMG.
# Requires root (writes to /Library/Fonts).
# The DMG contains a .pkg that must be installed via installer.
maclib::apps::applenyfonts::install() {
  local url dmg_path pkg_path tmp_dir
  url="$(maclib::apps::applenyfonts::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/NY.dmg"
  pkg_path="$tmp_dir/NY.pkg"

  # Download DMG
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "applenyfonts::install: failed to download DMG"
    return 1
  fi

  # Mount DMG
  local mount_point
  mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "applenyfonts::install: failed to mount DMG"
    return 1
  fi

  # Find and install the pkg
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "applenyfonts::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update is the same as install since fonts are pulled from CDN.
maclib::apps::applenyfonts::update() {
  maclib::apps::applenyfonts::install "$@"
}

# Uninstall: remove font files from /Library/Fonts.
maclib::apps::applenyfonts::uninstall() {
  local font
  for font in /Library/Fonts/New\ York*.ttf /Library/Fonts/New\ York*.otf; do
    [[ -f "$font" ]] && rm -f "$font" && \
      maclib::core::log::info "applenyfonts::uninstall: removed $font"
  done
}
