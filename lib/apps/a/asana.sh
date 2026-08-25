#!/usr/bin/env bash
# shellcheck disable=all
# asana.sh - "Asana" (Installomator label) helpers
#
# Vendor source: Installomator label asana from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "A679L395M8".
# Installer type: "dmg".
#

maclib::asana::suite_installer_url() {
  printf '%s\n' 'https://desktop-downloads.asana.com/darwin_universal/prod/latest/Asana.dmg'
}

maclib::asana::latest_version() {
  printf '%s\n' ''
}

maclib::asana::is_installed() {
  [[ -d "/Applications/Asana.app" ]] || [[ -d "$HOME/Applications/Asana.app" ]]
}

maclib::asana::installed_path() {
  if [[ -d "/Applications/Asana.app" ]]; then
    printf "%s\n" "/Applications/Asana.app"
  elif [[ -d "$HOME/Applications/Asana.app" ]]; then
    printf "%s\n" "$HOME/Applications/Asana.app"
  fi
}

maclib::asana::install() {
  local url tmp
  url="$(maclib::asana::suite_installer_url)"
  tmp="$(mktemp -d -t "asana.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "asana::install: download failed"
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

maclib::asana::update() {
  # No vendor update path documented for "Asana".
  maclib::log::error "asana::update: no update path"
  return 127
}

maclib::asana::uninstall() {
  # No clean uninstall for "Asana" (documented constraint).
  maclib::log::error "asana::uninstall: no clean uninstall"
  return 1
}
