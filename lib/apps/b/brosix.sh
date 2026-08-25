#!/usr/bin/env bash
# shellcheck disable=all
# brosix.sh - "Brosix" (Installomator label) helpers
#
# Vendor source: Installomator label brosix from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "TA6P23NW8H".
# Installer type: "pkg".
#

maclib::brosix::suite_installer_url() {
  printf '%s\n' 'https://www.brosix.com/downloads/builds/official/Brosix.pkg'
}

maclib::brosix::latest_version() {
  printf '%s\n' ''
}

maclib::brosix::is_installed() {
  [[ -d "/Applications/Brosix.app" ]] || [[ -d "$HOME/Applications/Brosix.app" ]]
}

maclib::brosix::installed_path() {
  if [[ -d "/Applications/Brosix.app" ]]; then
    printf "%s\n" "/Applications/Brosix.app"
  elif [[ -d "$HOME/Applications/Brosix.app" ]]; then
    printf "%s\n" "$HOME/Applications/Brosix.app"
  fi
}

maclib::brosix::install() {
  local url tmp
  url="$(maclib::brosix::suite_installer_url)"
  tmp="$(mktemp -d -t "brosix.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "brosix::install: download failed"
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

maclib::brosix::update() {
  # No vendor update path documented for "Brosix".
  maclib::log::error "brosix::update: no update path"
  return 127
}

maclib::brosix::uninstall() {
  # No clean uninstall for "Brosix" (documented constraint).
  maclib::log::error "brosix::uninstall: no clean uninstall"
  return 1
}
