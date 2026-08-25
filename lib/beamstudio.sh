#!/usr/bin/env bash
# shellcheck disable=all
# beamstudio.sh - "Beam Studio" (Installomator label) helpers
#
# Vendor source: Installomator label beamstudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "4Y92JWKV94".
# Installer type: "dmg".
#

maclib::beamstudio::suite_installer_url() {
  curl -s "https://id.flux3dp.com/api/check-update?key=beamstudio-stable" | tr '"' '\n' | grep -m1 dmg
}

maclib::beamstudio::latest_version() {
  echo "$downloadURL" | cut -d '+' -f 3 | cut -d '.' -f 1-3
}

maclib::beamstudio::is_installed() {
  [[ -d "/Applications/BeamStudio.app" ]] || [[ -d "$HOME/Applications/BeamStudio.app" ]]
}

maclib::beamstudio::installed_path() {
  if [[ -d "/Applications/BeamStudio.app" ]]; then
    printf "%s\n" "/Applications/BeamStudio.app"
  elif [[ -d "$HOME/Applications/BeamStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/BeamStudio.app"
  fi
}

maclib::beamstudio::install() {
  local url tmp
  url="$(maclib::beamstudio::suite_installer_url)"
  tmp="$(mktemp -d -t "beamstudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "beamstudio::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::beamstudio::update() {
  # No vendor update path documented for "Beam Studio".
  maclib::log::error "beamstudio::update: no update path"
  return 127
}

maclib::beamstudio::uninstall() {
  # No clean uninstall for "Beam Studio" (documented constraint).
  maclib::log::error "beamstudio::uninstall: no clean uninstall"
  return 1
}
