#!/usr/bin/env bash
# shellcheck disable=all
# arduinoide.sh - "Arduino IDE" (Installomator label) helpers
#
# Vendor source: Installomator label arduinoide from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "7KT7ZWMCJT".
# Installer type: "dmg".
#

maclib::arduinoide::suite_installer_url() {
  downloadURLFromGit arduino arduino-ide
}

maclib::arduinoide::latest_version() {
  versionFromGit arduino arduino-ide
}

maclib::arduinoide::is_installed() {
  [[ -d "/Applications/ArduinoIDE.app" ]] || [[ -d "$HOME/Applications/ArduinoIDE.app" ]]
}

maclib::arduinoide::installed_path() {
  if [[ -d "/Applications/ArduinoIDE.app" ]]; then
    printf "%s\n" "/Applications/ArduinoIDE.app"
  elif [[ -d "$HOME/Applications/ArduinoIDE.app" ]]; then
    printf "%s\n" "$HOME/Applications/ArduinoIDE.app"
  fi
}

maclib::arduinoide::install() {
  local url tmp
  url="$(maclib::arduinoide::suite_installer_url)"
  tmp="$(mktemp -d -t "arduinoide.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "arduinoide::install: download failed"
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

maclib::arduinoide::update() {
  # No vendor update path documented for "Arduino IDE".
  maclib::log::error "arduinoide::update: no update path"
  return 127
}

maclib::arduinoide::uninstall() {
  # No clean uninstall for "Arduino IDE" (documented constraint).
  maclib::log::error "arduinoide::uninstall: no clean uninstall"
  return 1
}
