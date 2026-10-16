#!/usr/bin/env bash
# shellcheck disable=all
# conductor.sh - Conductor (Installomator label) helpers
#
# Vendor source: Installomator label conductor from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::conductor::suite_installer_url() {
  # TODO: Add actual download URL for Conductor
  printf '%s\\n' 'https://example.com/conductor/installer'
}

maclib::media::conductor::latest_version() {
  # TODO: Add version detection for Conductor
  return 1
}

maclib::media::conductor::is_installed() {
  [[ -d "/Applications/Conductor.app" ]] || [[ -d "$HOME/Applications/Conductor.app" ]]
}

maclib::media::conductor::installed_path() {
  if [[ -d "/Applications/Conductor.app" ]]; then
    printf '%s\\n' "/Applications/Conductor.app"
  elif [[ -d "$HOME/Applications/Conductor.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Conductor.app"
  fi
}

maclib::conductor::install() {
  local url tmp mp app
  url="$(maclib::conductor::suite_installer_url)"
  tmp="$(mktemp -d -t "conductor.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "conductor::install: download failed"
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


maclib::media::conductor::update() {
  # No vendor update path documented for "Conductor".
  maclib::core::log::error "conductor::update: no update path"
  return 127
}

maclib::media::conductor::uninstall() {
  # No clean uninstall for "Conductor" (documented constraint).
  maclib::core::log::error "conductor::uninstall: no clean uninstall"
  return 1
}
