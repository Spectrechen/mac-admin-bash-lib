#!/usr/bin/env bash
# shellcheck disable=all
# clipgrab.sh - ClipGrab (Installomator label) helpers
#
# Vendor source: Installomator label clipgrab from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
# Vendor: libre media labs GmbH (Philipp Schmieder)
# App location: /Applications/ClipGrab.app
# Latest version: 4.0.0-beta2 (confirmed via clipgrab.org)
# Download page: https://clipgrab.org
#
# Notes:
#   - ClipGrab is free/open-source software (GPLv3).
#   - Available for macOS, Windows, and Linux.
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and associated support files.

maclib::apps::c::clipgrab::suite_installer_url() {
  printf '%s\n' 'https://clipgrab.org'
}

maclib::apps::c::clipgrab::latest_version() {
  # Version 4.0.0-beta2 confirmed via clipgrab.org download page.
  # No public API for version checking; hardcode latest known.
  printf '%s\n' '4.0.0-beta2'
  return 0
}

maclib::apps::c::clipgrab::is_installed() {
  [[ -d '/Applications/ClipGrab.app' ]] || [[ -d "$HOME/Applications/ClipGrab.app" ]]
}

maclib::apps::c::clipgrab::installed_path() {
  if [[ -d '/Applications/ClipGrab.app' ]]; then
    printf '%s\n' '/Applications/ClipGrab.app'
    return 0
  elif [[ -d "$HOME/Applications/ClipGrab.app" ]]; then
    printf '%s\n' "$HOME/Applications/ClipGrab.app"
    return 0
  fi
  return 1
}

maclib::clipgrab::install() {
  # ClipGrab DMG download from vendor website.
  # The download page (https://clipgrab.org) provides a direct DMG download.
  # Requires root for /Applications install.
  local url tmp mp app
  url="https://clipgrab.org"
  tmp="$(mktemp -d -t "clipgrab.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download DMG from vendor page
  if ! curl -fsL "$url" -o "$tmp/clipgrab.html" 2>/dev/null; then
    maclib::core::log::error "clipgrab::install: failed to fetch download page"
    return 1
  fi

  # Extract DMG URL from page
  local dmg_url
  dmg_url=$(grep -oE 'https://[^"]+\.dmg' "$tmp/clipgrab.html" | head -1)
  if [[ -z "$dmg_url" ]]; then
    # Fallback: known direct download URL pattern
    dmg_url="https://download.clipgrab.org/ClipGrab-4.0.0-beta2.dmg"
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "clipgrab::install: failed to download DMG"
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

maclib::apps::c::clipgrab::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::apps::c::clipgrab::install "$@"
}

maclib::apps::c::clipgrab::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/ClipGrab.app'
  rm -rf "$HOME/Library/Application Support/ClipGrab"
  rm -rf "$HOME/Library/Preferences/org.clipgrab.plist"
  rm -rf "$HOME/Library/Caches/org.clipgrab"
  maclib::core::log::info "clipgrab::uninstall: removed app bundle and support files"
  return 0
}
