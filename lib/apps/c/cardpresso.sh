#!/usr/bin/env bash
# shellcheck disable=all
# cardpresso.sh - "cardpresso" (Installomator label) helpers
#
# Vendor source: Installomator label cardpresso from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "QH48YJ244W".
# Installer type: "dmg".
#

maclib::cardpresso::suite_installer_url() {
  local appNewVersion
  appNewVersion=curl -is "https://formulae.brew.sh/cask/cardpresso" | grep 'Current version:' | grep -oie "[0-9\.]*\.dmg" | awk -F ".dmg" '{print $1}'
  https://www.cardpresso.com/downloads/cardpresso_releases/for_mac_osx/cardPresso${appNewVersion}.dmg
}

maclib::cardpresso::latest_version() {
  curl -is "https://formulae.brew.sh/cask/cardpresso" | grep 'Current version:' | grep -oie "[0-9\.]*\.dmg" | awk -F ".dmg" '{print $1}'
}

maclib::cardpresso::is_installed() {
  [[ -d "/Applications/cardpresso.app" ]] || [[ -d "$HOME/Applications/cardpresso.app" ]]
}

maclib::cardpresso::installed_path() {
  if [[ -d "/Applications/cardpresso.app" ]]; then
    printf "%s\n" "/Applications/cardpresso.app"
  elif [[ -d "$HOME/Applications/cardpresso.app" ]]; then
    printf "%s\n" "$HOME/Applications/cardpresso.app"
  fi
}

maclib::cardpresso::install() {
  local url tmp
  url="$(maclib::cardpresso::suite_installer_url)"
  tmp="$(mktemp -d -t "cardpresso.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cardpresso::install: download failed"
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

maclib::cardpresso::update() {
  # No vendor update path documented for "cardpresso".
  maclib::log::error "cardpresso::update: no update path"
  return 127
}

maclib::cardpresso::uninstall() {
  # No clean uninstall for "cardpresso" (documented constraint).
  maclib::log::error "cardpresso::uninstall: no clean uninstall"
  return 1
}
