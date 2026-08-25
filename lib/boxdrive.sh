#!/usr/bin/env bash
# shellcheck disable=all
# boxdrive.sh - "Box" (Installomator label) helpers
#
# Vendor source: Installomator label boxdrive from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "M683GB7CPW".
# Installer type: "pkg".
#

maclib::boxdrive::suite_installer_url() {
  getJSONValue "$macDetails" '["download-url"]'
}

maclib::boxdrive::latest_version() {
  getJSONValue "$macDetails" "version"
}

maclib::boxdrive::is_installed() {
  [[ -d "/Applications/Box.app" ]] || [[ -d "$HOME/Applications/Box.app" ]]
}

maclib::boxdrive::installed_path() {
  if [[ -d "/Applications/Box.app" ]]; then
    printf "%s\n" "/Applications/Box.app"
  elif [[ -d "$HOME/Applications/Box.app" ]]; then
    printf "%s\n" "$HOME/Applications/Box.app"
  fi
}

maclib::boxdrive::install() {
  local url tmp
  url="$(maclib::boxdrive::suite_installer_url)"
  tmp="$(mktemp -d -t "boxdrive.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "boxdrive::install: download failed"
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

maclib::boxdrive::update() {
  # No vendor update path documented for "Box".
  maclib::log::error "boxdrive::update: no update path"
  return 127
}

maclib::boxdrive::uninstall() {
  # No clean uninstall for "Box" (documented constraint).
  maclib::log::error "boxdrive::uninstall: no clean uninstall"
  return 1
}
