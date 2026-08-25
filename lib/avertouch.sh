#!/usr/bin/env bash
# shellcheck disable=all
# avertouch.sh - "AverTouch" (Installomator label) helpers
#
# Vendor source: Installomator label avertouch from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "B6T3WCD59Q".
# Installer type: "zip".
#

maclib::avertouch::suite_installer_url() {
  local appNewVersion
  appNewVersion=curl -s "https://www.averusa.com/education/support/avertouch" | xmllint --html --xpath 'substring-after(string(//a[@class="dl-avertouch-mac"]/@href), "AVerTouch_mac_v")' - 2>/dev/null | sed 's/\.zip$//'
  https://www.averusa.com/education/downloads/AVerTouch_mac_v${appNewVersion}.zip
}

maclib::avertouch::latest_version() {
  curl -s "https://www.averusa.com/education/support/avertouch" | xmllint --html --xpath 'substring-after(string(//a[@class="dl-avertouch-mac"]/@href), "AVerTouch_mac_v")' - 2>/dev/null | sed 's/\.zip$//'
}

maclib::avertouch::is_installed() {
  [[ -d "/Applications/AverTouch.app" ]] || [[ -d "$HOME/Applications/AverTouch.app" ]]
}

maclib::avertouch::installed_path() {
  if [[ -d "/Applications/AverTouch.app" ]]; then
    printf "%s\n" "/Applications/AverTouch.app"
  elif [[ -d "$HOME/Applications/AverTouch.app" ]]; then
    printf "%s\n" "$HOME/Applications/AverTouch.app"
  fi
}

maclib::avertouch::install() {
  local url tmp
  url="$(maclib::avertouch::suite_installer_url)"
  tmp="$(mktemp -d -t "avertouch.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "avertouch::install: download failed"
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

maclib::avertouch::update() {
  # No vendor update path documented for "AverTouch".
  maclib::log::error "avertouch::update: no update path"
  return 127
}

maclib::avertouch::uninstall() {
  # No clean uninstall for "AverTouch" (documented constraint).
  maclib::log::error "avertouch::uninstall: no clean uninstall"
  return 1
}
