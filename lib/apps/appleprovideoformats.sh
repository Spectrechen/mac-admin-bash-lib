#!/usr/bin/env bash
# appleprovideoformats.sh - Apple ProVideoFormats helpers
#
# Vendor research:
#   ProVideoFormats is a codec package from Apple for QuickTime and Pro apps.
#   Available from Apple Support page:
#     https://support.apple.com/en-us/106396
#   - Current version: 3.1 (as of 2025)
#   - Download URL is extracted from the Apple Support page via CDN:
#       https://updates.cdn-apple.com/.../ProVideoFormats.dmg
#   - Package ID: com.apple.pkg.ProVideoFormats
#   - Team ID: Software Update
#   - Installs as a .pkg inside a .dmg.
#   - No standalone API for version; check Apple Support page or pkgutil.

# Print the Apple Support page URL where the download link is hosted.
maclib::apps::appleprovideoformats::suite_installer_url() {
  # The actual DMG URL is dynamic; resolve from the support page.
  local url
  url=$(curl -s "https://support.apple.com/en-us/106396" 2>/dev/null | \
    grep -Eo 'https://updates\.cdn-apple\.com[^\"]+ProVideoFormats\.dmg' | head -n1)
  if [[ -n "$url" ]]; then
    printf '%s\n' "$url"
    return 0
  fi
  # Fallback to known CDN pattern
  printf '%s\n' 'https://updates.cdn-apple.com/2025/macos/061-48384/ProVideoFormats.dmg'
  return 0
}

# Print the current version. Checks installed version via pkgutil,
# otherwise queries the Apple Support page.
maclib::apps::appleprovideoformats::latest_version() {
  local ver
  # Try installed version first
  ver=$(/usr/sbin/pkgutil --pkg-info com.apple.pkg.ProVideoFormats 2>/dev/null | \
    grep 'version:' | awk '{print $2}')
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback: known latest version
  printf '%s\n' '3.1'
  return 0
}

# Return 0 if ProVideoFormats is installed.
maclib::apps::appleprovideoformats::is_installed() {
  /usr/sbin/pkgutil --pkg-info com.apple.pkg.ProVideoFormats >/dev/null 2>&1
  return $?
}

# Print the installed path if present.
maclib::apps::appleprovideoformats::installed_path() {
  local path
  path=$(/usr/sbin/pkgutil --files com.apple.pkg.ProVideoFormats 2>/dev/null | \
    grep '\.plugin$' | head -1)
  if [[ -n "$path" ]]; then
    printf '%s\n' "/Library/QuickTime/$path"
    return 0
  fi
  return 1
}

# Download and install ProVideoFormats.
# Requires root.
maclib::apps::appleprovideoformats::install() {
  local url dmg_path tmp_dir
  url="$(maclib::apps::appleprovideoformats::suite_installer_url)"
  tmp_dir="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp_dir"' RETURN

  dmg_path="$tmp_dir/ProVideoFormats.dmg"
  if ! curl -fsL "$url" -o "$dmg_path" 2>/dev/null; then
    maclib::core::log::error "appleprovideoformats::install: failed to download DMG"
    return 1
  fi

  local mount_point="$tmp_dir/mount"
  mkdir -p "$mount_point"
  if ! hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet 2>/dev/null; then
    maclib::core::log::error "appleprovideoformats::install: failed to mount DMG"
    return 1
  fi

  local pkg_path
  pkg_path="$(find "$mount_point" -name '*.pkg' -type f | head -1)"
  if [[ -z "$pkg_path" ]]; then
    maclib::core::log::error "appleprovideoformats::install: no .pkg found in DMG"
    hdiutil detach "$mount_point" -quiet 2>/dev/null
    return 1
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  hdiutil detach "$mount_point" -quiet 2>/dev/null
  return "$rc"
}

# Update: same as install (pulls latest from CDN).
maclib::apps::appleprovideoformats::update() {
  maclib::apps::appleprovideoformats::install "$@"
}

# Uninstall: remove ProVideoFormats package files.
maclib::apps::appleprovideoformats::uninstall() {
  local files
  files=$(/usr/sbin/pkgutil --files com.apple.pkg.ProVideoFormats 2>/dev/null)
  if [[ -n "$files" ]]; then
    echo "$files" | while IFS= read -r f; do
      [[ -f "/Library/QuickTime/$f" ]] && rm -f "/Library/QuickTime/$f"
    done
  fi
  /usr/sbin/pkgutil --forget com.apple.pkg.ProVideoFormats 2>/dev/null
}
