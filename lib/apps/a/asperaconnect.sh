#!/usr/bin/env bash
# shellcheck disable=all
# asperaconnect.sh - "Aspera Connect" (Installomator label) helpers
#
# Vendor source: Installomator label asperaconnect from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "PETKK2G752".
# Installer type: "module"' | grep -o "/.*.js").
#

maclib::asperaconnect::suite_installer_url() {
  ${downloadBaseUrl}/latest/$(echo ${appInfo} | jq -r '.entries.[] | select(.title == "Aspera Connect for macOS").links.[] | select(.rel == "enclosure-one-click").href')
}

maclib::asperaconnect::latest_version() {
  echo ${appInfo} | jq -r '.entries.[] | select(.title == "Aspera Connect for macOS") | .version' | awk -F "." '{print$1"."$2"."$3}'
}

maclib::asperaconnect::is_installed() {
  [[ -d "/Applications/AsperaConnect.app" ]] || [[ -d "$HOME/Applications/AsperaConnect.app" ]]
}

maclib::asperaconnect::installed_path() {
  if [[ -d "/Applications/AsperaConnect.app" ]]; then
    printf "%s\n" "/Applications/AsperaConnect.app"
  elif [[ -d "$HOME/Applications/AsperaConnect.app" ]]; then
    printf "%s\n" "$HOME/Applications/AsperaConnect.app"
  fi
}

maclib::asperaconnect::install() {
  local url tmp
  url="$(maclib::asperaconnect::suite_installer_url)"
  tmp="$(mktemp -d -t "asperaconnect.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "asperaconnect::install: download failed"
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

maclib::asperaconnect::update() {
  # No vendor update path documented for "Aspera Connect".
  maclib::log::error "asperaconnect::update: no update path"
  return 127
}

maclib::asperaconnect::uninstall() {
  # No clean uninstall for "Aspera Connect" (documented constraint).
  maclib::log::error "asperaconnect::uninstall: no clean uninstall"
  return 1
}
