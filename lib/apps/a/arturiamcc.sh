#!/usr/bin/env bash
# shellcheck disable=all
# arturiamcc.sh - "MIDI Control Center" (Installomator label) helpers
#
# Vendor source: Installomator label arturiamcc from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "T53ZHSF36C".
# Installer type: "pkg".
#

maclib::arturiamcc::suite_installer_url() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].permalink"
}

maclib::arturiamcc::latest_version() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].version"
}

maclib::arturiamcc::is_installed() {
  [[ -d "/Applications/MIDIControlCenter.app" ]] || [[ -d "$HOME/Applications/MIDIControlCenter.app" ]]
}

maclib::arturiamcc::installed_path() {
  if [[ -d "/Applications/MIDIControlCenter.app" ]]; then
    printf "%s\n" "/Applications/MIDIControlCenter.app"
  elif [[ -d "$HOME/Applications/MIDIControlCenter.app" ]]; then
    printf "%s\n" "$HOME/Applications/MIDIControlCenter.app"
  fi
}

maclib::arturiamcc::install() {
  local url tmp
  url="$(maclib::arturiamcc::suite_installer_url)"
  tmp="$(mktemp -d -t "arturiamcc.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "arturiamcc::install: download failed"
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

maclib::arturiamcc::update() {
  # No vendor update path documented for "MIDI Control Center".
  maclib::log::error "arturiamcc::update: no update path"
  return 127
}

maclib::arturiamcc::uninstall() {
  # No clean uninstall for "MIDI Control Center" (documented constraint).
  maclib::log::error "arturiamcc::uninstall: no clean uninstall"
  return 1
}
