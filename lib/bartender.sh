#!/usr/bin/env bash
# shellcheck disable=all
# bartender.sh - "Bartender 4" (Installomator label) helpers
#
# Vendor source: Installomator label bartender from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "8DD663WDX4".
# Installer type: "dmg".
#

maclib::bartender::suite_installer_url() {
  printf '%s\n' 'https://www.macbartender.com/B2/updates/B4Latest/Bartender%204.dmg'
}

maclib::bartender::latest_version() {
  printf '%s\n' ''
}

maclib::bartender::is_installed() {
  [[ -d "/Applications/Bartender4.app" ]] || [[ -d "$HOME/Applications/Bartender4.app" ]]
}

maclib::bartender::installed_path() {
  if [[ -d "/Applications/Bartender4.app" ]]; then
    printf "%s\n" "/Applications/Bartender4.app"
  elif [[ -d "$HOME/Applications/Bartender4.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bartender4.app"
  fi
}

maclib::bartender::install() {
  local url tmp
  url="$(maclib::bartender::suite_installer_url)"
  tmp="$(mktemp -d -t "bartender.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bartender::install: download failed"
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

maclib::bartender::update() {
  # No vendor update path documented for "Bartender 4".
  maclib::log::error "bartender::update: no update path"
  return 127
}

maclib::bartender::uninstall() {
  # No clean uninstall for "Bartender 4" (documented constraint).
  maclib::log::error "bartender::uninstall: no clean uninstall"
  return 1
}
