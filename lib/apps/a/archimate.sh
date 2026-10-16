#!/usr/bin/env bash
# shellcheck disable=all
# archimate.sh - "Archi" (Installomator label) helpers
#
# Vendor source: Installomator label archimate
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (open source — ArchiMate Tool community).
# Installer type: "dmg".
# Installer URL: https://www.archimatetool.com/archi/Archi-latest.dmg (latest DMG).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#
# Sources:
#   https://www.archimatetool.com/download/
#   https://github.com/archimatetool/archi

maclib::apps::a::archimate::suite_installer_url() {
  printf '%s\n' "https://www.archimatetool.com/archi/Archi-latest.dmg"
}

maclib::apps::a::archimate::latest_version() {
  local html ver
  html="$(curl -fsL "https://github.com/archimatetool/archi/releases" 2>/dev/null)"
  if [[ "$html" =~ tag/v([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="5.9.0"
  fi
  printf '%s\n' "$ver"
}

maclib::apps::a::archimate::is_installed() {
  [[ -d "/Applications/Archi.app" ]] || [[ -d "$HOME/Applications/Archi.app" ]]
}

maclib::apps::a::archimate::installed_path() {
  if [[ -d "/Applications/Archi.app" ]]; then
    printf '%s\n' "/Applications/Archi.app"
  elif [[ -d "$HOME/Applications/Archi.app" ]]; then
    printf '%s\n' "$HOME/Applications/Archi.app"
  else
    return 1
  fi
}

maclib::apps::a::archimate::install() {
  local url tmp
  url="$(maclib::apps::a::archimate::suite_installer_url)"
  tmp="$(mktemp -d -t "archimate.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "archimate::install: download failed"
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

maclib::apps::a::archimate::update() {
  maclib::apps::a::archimate::install
}

maclib::apps::a::archimate::uninstall() {
  maclib::core::log::warn "archimate::uninstall: no clean uninstall"
  return 1
}
