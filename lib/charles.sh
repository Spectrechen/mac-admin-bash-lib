#!/usr/bin/env bash
# shellcheck disable=all
# charles.sh - "Charles" (Installomator label) helpers
#
# Vendor source: Installomator label charles from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "9A5PCU4FSD".
# Installer type: "dmg".
#

maclib::charles::suite_installer_url() {
  https://www.charlesproxy.com/assets/release/$appNewVersion/charles-proxy-$appNewVersion.dmg
}

maclib::charles::latest_version() {
  curl -fs https://www.charlesproxy.com/download/latest-release/ | sed -nE 's/.*version.*value="([^"]*).*/\1/p'
}

maclib::charles::is_installed() {
  [[ -d "/Applications/Charles.app" ]] || [[ -d "$HOME/Applications/Charles.app" ]]
}

maclib::charles::installed_path() {
  if [[ -d "/Applications/Charles.app" ]]; then
    printf "%s\n" "/Applications/Charles.app"
  elif [[ -d "$HOME/Applications/Charles.app" ]]; then
    printf "%s\n" "$HOME/Applications/Charles.app"
  fi
}

maclib::charles::install() {
  local url tmp
  url="$(maclib::charles::suite_installer_url)"
  tmp="$(mktemp -d -t "charles.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "charles::install: download failed"
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

maclib::charles::update() {
  # No vendor update path documented for "Charles".
  maclib::log::error "charles::update: no update path"
  return 127
}

maclib::charles::uninstall() {
  # No clean uninstall for "Charles" (documented constraint).
  maclib::log::error "charles::uninstall: no clean uninstall"
  return 1
}
