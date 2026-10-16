#!/usr/bin/env bash
# shellcheck disable=all
# dracoon.sh - Dracoon (Installomator label) helpers
#
# Vendor source: Installomator label dracoon from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::cloud_storage::dracoon::suite_installer_url() {
  # TODO: Add actual download URL for Dracoon
  printf '%s\\n' 'https://example.com/dracoon/installer'
}

maclib::cloud_storage::dracoon::latest_version() {
  # TODO: Add version detection for Dracoon
  return 1
}

maclib::cloud_storage::dracoon::is_installed() {
  [[ -d "/Applications/Dracoon.app" ]] || [[ -d "$HOME/Applications/Dracoon.app" ]]
}

maclib::cloud_storage::dracoon::installed_path() {
  if [[ -d "/Applications/Dracoon.app" ]]; then
    printf '%s\\n' "/Applications/Dracoon.app"
  elif [[ -d "$HOME/Applications/Dracoon.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dracoon.app"
  fi
}

maclib::dracoon::install() {
  local url tmp
  url="$(maclib::dracoon::suite_installer_url)"
  tmp="$(mktemp -d -t "dracoon.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "dracoon::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::cloud_storage::dracoon::update() {
  # No vendor update path documented for "Dracoon".
  maclib::core::log::error "dracoon::update: no update path"
  return 127
}

maclib::cloud_storage::dracoon::uninstall() {
  # No clean uninstall for "Dracoon" (documented constraint).
  maclib::core::log::error "dracoon::uninstall: no clean uninstall"
  return 1
}
