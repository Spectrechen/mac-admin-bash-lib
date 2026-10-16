#!/usr/bin/env bash
# shellcheck disable=all
# clevershare2.sh - CleverShare (Installomator label) helpers
#
# Vendor source: Installomator label clevershare2 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
# Vendor: Clevertouch Technologies (now part of Boxlight Corporation)
# App location: /Applications/Clevershare.app
# Latest version: N/A (free app, no versioned releases documented)
# Download page: https://www.clevertouch.com/clevershare2g
#
# Notes:
#   - CleverShare is a free app for screen sharing to Clevertouch panels.
#   - Download URL: clevertouch.com/clevershare2g (redirects to download).
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and associated support files.

maclib::cloud_storage::clevershare2::suite_installer_url() {
  printf '%s\n' 'https://www.clevertouch.com/clevershare2g'
}

maclib::cloud_storage::clevershare2::latest_version() {
  # No versioned releases documented for CleverShare.
  # The app is free and updated silently via the vendor website.
  printf '%s\n' 'latest'
  return 0
}

maclib::cloud_storage::clevershare2::is_installed() {
  [[ -d '/Applications/Clevershare.app' ]] || [[ -d "$HOME/Applications/Clevershare.app" ]]
}

maclib::cloud_storage::clevershare2::installed_path() {
  if [[ -d '/Applications/Clevershare.app' ]]; then
    printf '%s\n' '/Applications/Clevershare.app'
    return 0
  elif [[ -d "$HOME/Applications/Clevershare.app" ]]; then
    printf '%s\n' "$HOME/Applications/Clevershare.app"
    return 0
  fi
  return 1
}

maclib::clevershare2::install() {
  # CleverShare DMG download from vendor website.
  # The download page (https://www.clevertouch.com/clevershare2g) provides a direct DMG download.
  # Requires root for /Applications install.
  local url tmp mp app
  url="https://www.clevertouch.com/clevershare2g"
  tmp="$(mktemp -d -t "clevershare2.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download DMG from vendor page
  if ! curl -fsL "$url" -o "$tmp/clevershare.html" 2>/dev/null; then
    maclib::core::log::error "clevershare2::install: failed to fetch download page"
    return 1
  fi

  # Extract DMG URL from page
  local dmg_url
  dmg_url=$(grep -oE 'https://[^"]+\.dmg' "$tmp/clevershare.html" | head -1)
  if [[ -z "$dmg_url" ]]; then
    # Fallback: known direct download URL pattern
    dmg_url="https://www.clevertouch.com/downloads/Clevershare.dmg"
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "clevershare2::install: failed to download DMG"
    rm -rf "$tmp"
    return 1
  fi

  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::cloud_storage::clevershare2::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::cloud_storage::clevershare2::install "$@"
}

maclib::cloud_storage::clevershare2::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Clevershare.app'
  rm -rf "$HOME/Library/Application Support/Clevershare"
  rm -rf "$HOME/Library/Preferences/com.clevertouch.Clevershare.plist"
  rm -rf "$HOME/Library/Caches/com.clevertouch.Clevershare"
  maclib::core::log::info "clevershare2::uninstall: removed app bundle and support files"
  return 0
}
