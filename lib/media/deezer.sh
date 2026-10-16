#!/usr/bin/env bash
# shellcheck disable=all
# deezer.sh - Deezer (Installomator label) helpers
#
# Vendor source: Installomator label deezer from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::deezer::suite_installer_url() {
  # TODO: Add actual download URL for Deezer
  printf '%s\\n' 'https://example.com/deezer/installer'
}

maclib::media::deezer::latest_version() {
  # TODO: Add version detection for Deezer
  return 1
}

maclib::media::deezer::is_installed() {
  [[ -d "/Applications/Deezer.app" ]] || [[ -d "$HOME/Applications/Deezer.app" ]]
}

maclib::media::deezer::installed_path() {
  if [[ -d "/Applications/Deezer.app" ]]; then
    printf '%s\\n' "/Applications/Deezer.app"
  elif [[ -d "$HOME/Applications/Deezer.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Deezer.app"
  fi
}

maclib::deezer::install() {
  local url tmp mp app
  url="$(maclib::deezer::suite_installer_url)"
  tmp="$(mktemp -d -t "deezer.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "deezer::install: download failed"
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


maclib::media::deezer::update() {
  # No vendor update path documented for "Deezer".
  maclib::core::log::error "deezer::update: no update path"
  return 127
}

maclib::media::deezer::uninstall() {
  # No clean uninstall for "Deezer" (documented constraint).
  maclib::core::log::error "deezer::uninstall: no clean uninstall"
  return 1
}
