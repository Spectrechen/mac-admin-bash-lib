#!/usr/bin/env bash
# shellcheck disable=all
# camostudio.sh - "Camo Studio" (Installomator label) helpers
#
# Vendor source: Installomator label camostudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "Q248YREB53".
# Installer type: "zip".
#

maclib::camostudio::suite_installer_url() {
  https://reincubate.com/res/labs/camo/camo-macos-latest.zip
}

maclib::camostudio::latest_version() {
  curl -fs "https://uds.reincubate.com/release-notes/camo/" | head -1 | cut -d "," -f3 | grep -o -e "[0-9.]*"
}

maclib::camostudio::is_installed() {
  [[ -d "/Applications/CamoStudio.app" ]] || [[ -d "$HOME/Applications/CamoStudio.app" ]]
}

maclib::camostudio::installed_path() {
  if [[ -d "/Applications/CamoStudio.app" ]]; then
    printf "%s\n" "/Applications/CamoStudio.app"
  elif [[ -d "$HOME/Applications/CamoStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/CamoStudio.app"
  fi
}

maclib::camostudio::install() {
  local url tmp
  url="$(maclib::camostudio::suite_installer_url)"
  tmp="$(mktemp -d -t "camostudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "camostudio::install: download failed"
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

maclib::camostudio::update() {
  # No vendor update path documented for "Camo Studio".
  maclib::log::error "camostudio::update: no update path"
  return 127
}

maclib::camostudio::uninstall() {
  # No clean uninstall for "Camo Studio" (documented constraint).
  maclib::log::error "camostudio::uninstall: no clean uninstall"
  return 1
}
