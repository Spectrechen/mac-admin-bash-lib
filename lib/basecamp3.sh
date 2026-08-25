#!/usr/bin/env bash
# shellcheck disable=all
# basecamp3.sh - "Basecamp 3" (Installomator label) helpers
#
# Vendor source: Installomator label basecamp3 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "2WNYUYRS7G".
# Installer type: "zip".
#

maclib::basecamp3::suite_installer_url() {
  getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac/updates.json)" "url"
}

maclib::basecamp3::latest_version() {
  getJSONValue "$(curl -fsL https://basecamp.com/desktop/mac/updates.json)" "version"
}

maclib::basecamp3::is_installed() {
  [[ -d "/Applications/Basecamp3.app" ]] || [[ -d "$HOME/Applications/Basecamp3.app" ]]
}

maclib::basecamp3::installed_path() {
  if [[ -d "/Applications/Basecamp3.app" ]]; then
    printf "%s\n" "/Applications/Basecamp3.app"
  elif [[ -d "$HOME/Applications/Basecamp3.app" ]]; then
    printf "%s\n" "$HOME/Applications/Basecamp3.app"
  fi
}

maclib::basecamp3::install() {
  local url tmp
  url="$(maclib::basecamp3::suite_installer_url)"
  tmp="$(mktemp -d -t "basecamp3.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "basecamp3::install: download failed"
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

maclib::basecamp3::update() {
  # No vendor update path documented for "Basecamp 3".
  maclib::log::error "basecamp3::update: no update path"
  return 127
}

maclib::basecamp3::uninstall() {
  # No clean uninstall for "Basecamp 3" (documented constraint).
  maclib::log::error "basecamp3::uninstall: no clean uninstall"
  return 1
}
