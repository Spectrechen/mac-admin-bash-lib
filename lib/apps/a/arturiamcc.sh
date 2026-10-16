#!/usr/bin/env bash
# shellcheck disable=all
# arturiamcc.sh - "MIDI Control Center" (Installomator label) helpers
#
# Vendor source: Installomator label arturiamcc from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "T53ZHSF36C".
# Installer type: "pkg".
#

maclib::apps::a::arturiamcc::suite_installer_url() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].permalink"
}

maclib::apps::a::arturiamcc::latest_version() {
  getJSONValue "$arturiaDetails" "[$arturiaCount].version"
}

maclib::apps::a::arturiamcc::is_installed() {
  [[ -d "/Applications/MIDIControlCenter.app" ]] || [[ -d "$HOME/Applications/MIDIControlCenter.app" ]]
}

maclib::apps::a::arturiamcc::installed_path() {
  if [[ -d "/Applications/MIDIControlCenter.app" ]]; then
    printf "%s\n" "/Applications/MIDIControlCenter.app"
  elif [[ -d "$HOME/Applications/MIDIControlCenter.app" ]]; then
    printf "%s\n" "$HOME/Applications/MIDIControlCenter.app"
  fi
}

maclib::apps::a::arturiamcc::install() {
  local url tmp
  url="$(maclib::apps::a::arturiamcc::suite_installer_url)"
  tmp="$(mktemp -d -t "arturiamcc.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "arturiamcc::install: download failed"
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

maclib::apps::a::arturiamcc::update() {
  # No vendor update path documented for "MIDI Control Center".
  maclib::core::log::error "arturiamcc::update: no update path"
  return 127
}

maclib::apps::a::arturiamcc::uninstall() {
  # No clean uninstall for "MIDI Control Center" (documented constraint).
  maclib::core::log::error "arturiamcc::uninstall: no clean uninstall"
  return 1
}
