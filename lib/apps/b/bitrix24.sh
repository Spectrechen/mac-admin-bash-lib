#!/usr/bin/env bash
# shellcheck disable=all
# bitrix24.sh - "Bitrix24" (Installomator label) helpers
#
# Vendor source: Installomator label bitrix24 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "5B3T3A994N".
# Installer type: "dmg".
#

maclib::bitrix24::suite_installer_url() {
  https://dl.bitrix24.com/b24/bitrix24_desktop.dmg
}

maclib::bitrix24::latest_version() {
  curl -fs "https://www.bitrix24.com/osx_version.php" | xpath 'string(//rss/channel/item/title)' 2>/dev/null
}

maclib::bitrix24::is_installed() {
  [[ -d "/Applications/Bitrix24.app" ]] || [[ -d "$HOME/Applications/Bitrix24.app" ]]
}

maclib::bitrix24::installed_path() {
  if [[ -d "/Applications/Bitrix24.app" ]]; then
    printf "%s\n" "/Applications/Bitrix24.app"
  elif [[ -d "$HOME/Applications/Bitrix24.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bitrix24.app"
  fi
}

maclib::bitrix24::install() {
  local url tmp
  url="$(maclib::bitrix24::suite_installer_url)"
  tmp="$(mktemp -d -t "bitrix24.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bitrix24::install: download failed"
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

maclib::bitrix24::update() {
  # No vendor update path documented for "Bitrix24".
  maclib::log::error "bitrix24::update: no update path"
  return 127
}

maclib::bitrix24::uninstall() {
  # No clean uninstall for "Bitrix24" (documented constraint).
  maclib::log::error "bitrix24::uninstall: no clean uninstall"
  return 1
}
