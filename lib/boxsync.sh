#!/usr/bin/env bash
# shellcheck disable=all
# boxsync.sh - "Box Sync" (Installomator label) helpers
#
# Vendor source: Installomator label boxsync from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "M683GB7CPW".
# Installer type: "dmg".
#

maclib::boxsync::suite_installer_url() {
  printf '%s\n' 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/Box%20Sync%20Installer.dmg'
}

maclib::boxsync::latest_version() {
  printf '%s\n' ''
}

maclib::boxsync::is_installed() {
  [[ -d "/Applications/BoxSync.app" ]] || [[ -d "$HOME/Applications/BoxSync.app" ]]
}

maclib::boxsync::installed_path() {
  if [[ -d "/Applications/BoxSync.app" ]]; then
    printf "%s\n" "/Applications/BoxSync.app"
  elif [[ -d "$HOME/Applications/BoxSync.app" ]]; then
    printf "%s\n" "$HOME/Applications/BoxSync.app"
  fi
}

maclib::boxsync::install() {
  local url tmp
  url="$(maclib::boxsync::suite_installer_url)"
  tmp="$(mktemp -d -t "boxsync.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "boxsync::install: download failed"
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

maclib::boxsync::update() {
  # No vendor update path documented for "Box Sync".
  maclib::log::error "boxsync::update: no update path"
  return 127
}

maclib::boxsync::uninstall() {
  # No clean uninstall for "Box Sync" (documented constraint).
  maclib::log::error "boxsync::uninstall: no clean uninstall"
  return 1
}
