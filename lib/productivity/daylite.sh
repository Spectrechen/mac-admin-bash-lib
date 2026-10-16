#!/usr/bin/env bash
# shellcheck disable=all
# daylite.sh - Daylite (Installomator label) helpers
#
# Vendor source: Installomator label daylite from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::productivity::daylite::suite_installer_url() {
  # TODO: Add actual download URL for Daylite
  printf '%s\\n' 'https://example.com/daylite/installer'
}

maclib::productivity::daylite::latest_version() {
  # TODO: Add version detection for Daylite
  return 1
}

maclib::productivity::daylite::is_installed() {
  [[ -d "/Applications/Daylite.app" ]] || [[ -d "$HOME/Applications/Daylite.app" ]]
}

maclib::productivity::daylite::installed_path() {
  if [[ -d "/Applications/Daylite.app" ]]; then
    printf '%s\\n' "/Applications/Daylite.app"
  elif [[ -d "$HOME/Applications/Daylite.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Daylite.app"
  fi
}

maclib::daylite::install() {
  local url tmp
  url="$(maclib::daylite::suite_installer_url)"
  tmp="$(mktemp -d -t "daylite.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "daylite::install: download failed"
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


maclib::productivity::daylite::update() {
  # No vendor update path documented for "Daylite".
  maclib::core::log::error "daylite::update: no update path"
  return 127
}

maclib::productivity::daylite::uninstall() {
  # No clean uninstall for "Daylite" (documented constraint).
  maclib::core::log::error "daylite::uninstall: no clean uninstall"
  return 1
}
