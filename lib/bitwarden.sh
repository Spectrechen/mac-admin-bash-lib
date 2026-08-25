#!/usr/bin/env bash
# shellcheck disable=all
# bitwarden.sh - "Bitwarden" (Installomator label) helpers
#
# Vendor source: Installomator label bitwarden from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "LTZ2PFU5D6".
# Installer type: "dmg".
#

maclib::bitwarden::suite_installer_url() {
  local appNewVersion
  appNewVersion=curl -s "https://github.com/bitwarden/clients/releases?q\=desktop" | xmllint --html --xpath 'substring-after(string(//h2[starts-with(text(),"Desktop v")]), " v")' - 2>/dev/null
  https://github.com/bitwarden/clients/releases/download/desktop-v${appNewVersion}/Bitwarden-${appNewVersion}-universal.dmg
}

maclib::bitwarden::latest_version() {
  curl -s "https://github.com/bitwarden/clients/releases?q\=desktop" | xmllint --html --xpath 'substring-after(string(//h2[starts-with(text(),"Desktop v")]), " v")' - 2>/dev/null
}

maclib::bitwarden::is_installed() {
  [[ -d "/Applications/Bitwarden.app" ]] || [[ -d "$HOME/Applications/Bitwarden.app" ]]
}

maclib::bitwarden::installed_path() {
  if [[ -d "/Applications/Bitwarden.app" ]]; then
    printf "%s\n" "/Applications/Bitwarden.app"
  elif [[ -d "$HOME/Applications/Bitwarden.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bitwarden.app"
  fi
}

maclib::bitwarden::install() {
  local url tmp
  url="$(maclib::bitwarden::suite_installer_url)"
  tmp="$(mktemp -d -t "bitwarden.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bitwarden::install: download failed"
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

maclib::bitwarden::update() {
  # No vendor update path documented for "Bitwarden".
  maclib::log::error "bitwarden::update: no update path"
  return 127
}

maclib::bitwarden::uninstall() {
  # No clean uninstall for "Bitwarden" (documented constraint).
  maclib::log::error "bitwarden::uninstall: no clean uninstall"
  return 1
}
