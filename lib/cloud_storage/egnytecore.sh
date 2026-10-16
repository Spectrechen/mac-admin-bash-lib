#!/usr/bin/env bash
# shellcheck disable=all
# egnytecore.sh - Egnyte Core (Installomator label) helpers
#
# Vendor source: Installomator label egnytecore from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::cloud_storage::egnytecore::suite_installer_url() {
  # TODO: Add actual download URL for Egnyte Core
  printf '%s\\n' 'https://example.com/egnytecore/installer'
}

maclib::cloud_storage::egnytecore::latest_version() {
  # TODO: Add version detection for Egnyte Core
  return 1
}

maclib::cloud_storage::egnytecore::is_installed() {
  [[ -d "/Applications/Egnyte Core.app" ]] || [[ -d "$HOME/Applications/Egnyte Core.app" ]]
}

maclib::cloud_storage::egnytecore::installed_path() {
  if [[ -d "/Applications/Egnyte Core.app" ]]; then
    printf '%s\\n' "/Applications/Egnyte Core.app"
  elif [[ -d "$HOME/Applications/Egnyte Core.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Egnyte Core.app"
  fi
}

maclib::egnytecore::install() {
  local url tmp mp app
  url="$(maclib::egnytecore::suite_installer_url)"
  tmp="$(mktemp -d -t "egnytecore.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "egnytecore::install: download failed"
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


maclib::cloud_storage::egnytecore::update() {
  # No vendor update path documented for "Egnyte Core".
  maclib::core::log::error "egnytecore::update: no update path"
  return 127
}

maclib::cloud_storage::egnytecore::uninstall() {
  # No clean uninstall for "Egnyte Core" (documented constraint).
  maclib::core::log::error "egnytecore::uninstall: no clean uninstall"
  return 1
}
