#!/usr/bin/env bash
# shellcheck disable=all
# bitwigstudio.sh - "Bitwig Studio" (Installomator label) helpers
#
# Vendor source: Installomator label bitwigstudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "2B6K987585".
# Installer type: "dmg".
#

maclib::bitwigstudio::suite_installer_url() {
  echo $bitwigDetails | grep -o 'https://[^"]*'
}

maclib::bitwigstudio::latest_version() {
  echo $bitwigDetails | grep -o 'Studio/[^/]*/installer' | awk -F'/' '{print $2}'
}

maclib::bitwigstudio::is_installed() {
  [[ -d "/Applications/BitwigStudio.app" ]] || [[ -d "$HOME/Applications/BitwigStudio.app" ]]
}

maclib::bitwigstudio::installed_path() {
  if [[ -d "/Applications/BitwigStudio.app" ]]; then
    printf "%s\n" "/Applications/BitwigStudio.app"
  elif [[ -d "$HOME/Applications/BitwigStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/BitwigStudio.app"
  fi
}

maclib::bitwigstudio::install() {
  local url tmp
  url="$(maclib::bitwigstudio::suite_installer_url)"
  tmp="$(mktemp -d -t "bitwigstudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bitwigstudio::install: download failed"
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

maclib::bitwigstudio::update() {
  # No vendor update path documented for "Bitwig Studio".
  maclib::log::error "bitwigstudio::update: no update path"
  return 127
}

maclib::bitwigstudio::uninstall() {
  # No clean uninstall for "Bitwig Studio" (documented constraint).
  maclib::log::error "bitwigstudio::uninstall: no clean uninstall"
  return 1
}
