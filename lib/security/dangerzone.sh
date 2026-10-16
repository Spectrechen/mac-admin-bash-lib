#!/usr/bin/env bash
# shellcheck disable=all
# dangerzone.sh - Dangerzone (Installomator label) helpers
#
# Vendor source: Installomator label dangerzone from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::security::dangerzone::suite_installer_url() {
  # TODO: Add actual download URL for Dangerzone
  printf '%s\\n' 'https://example.com/dangerzone/installer'
}

maclib::security::dangerzone::latest_version() {
  # TODO: Add version detection for Dangerzone
  return 1
}

maclib::security::dangerzone::is_installed() {
  [[ -d "/Applications/Dangerzone.app" ]] || [[ -d "$HOME/Applications/Dangerzone.app" ]]
}

maclib::security::dangerzone::installed_path() {
  if [[ -d "/Applications/Dangerzone.app" ]]; then
    printf '%s\\n' "/Applications/Dangerzone.app"
  elif [[ -d "$HOME/Applications/Dangerzone.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dangerzone.app"
  fi
}

maclib::dangerzone::install() {
  local url tmp mp app
  url="$(maclib::dangerzone::suite_installer_url)"
  tmp="$(mktemp -d -t "dangerzone.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dangerzone::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::security::dangerzone::update() {
  # No vendor update path documented for "Dangerzone".
  maclib::core::log::error "dangerzone::update: no update path"
  return 127
}

maclib::security::dangerzone::uninstall() {
  # No clean uninstall for "Dangerzone" (documented constraint).
  maclib::core::log::error "dangerzone::uninstall: no clean uninstall"
  return 1
}
