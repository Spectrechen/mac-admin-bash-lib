#!/usr/bin/env bash
# shellcheck disable=all
# archaeology.sh - "Archaeology" (Installomator label) helpers
#
# Vendor source: Installomator label archaeology
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (Mothers Ruin Software — verify against vendor).
# Installer type: "dmg".
# Installer URL: https://www.mothersruin.com/software/Archaeology/Archaeology.dmg (direct DMG).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#
# Sources:
#   https://www.mothersruin.com/software/Archaeology/get.html
#   https://macupdater.net/app_updates/appinfo/com.mothersruin.Archaeology/

maclib::apps::a::archaeology::suite_installer_url() {
  printf '%s\n' "https://www.mothersruin.com/software/Archaeology/Archaeology.dmg"
}

maclib::apps::a::archaeology::latest_version() {
  local html ver
  html="$(curl -fsL "https://macupdater.net/app_updates/appinfo/com.mothersruin.Archaeology/" 2>/dev/null)"
  if [[ "$html" =~ v([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.4"
  fi
  printf '%s\n' "$ver"
}

maclib::apps::a::archaeology::is_installed() {
  [[ -d "/Applications/Archaeology.app" ]] || [[ -d "$HOME/Applications/Archaeology.app" ]]
}

maclib::apps::a::archaeology::installed_path() {
  if [[ -d "/Applications/Archaeology.app" ]]; then
    printf '%s\n' "/Applications/Archaeology.app"
  elif [[ -d "$HOME/Applications/Archaeology.app" ]]; then
    printf '%s\n' "$HOME/Applications/Archaeology.app"
  else
    return 1
  fi
}

maclib::apps::a::archaeology::install() {
  local url tmp
  url="$(maclib::apps::a::archaeology::suite_installer_url)"
  tmp="$(mktemp -d -t "archaeology.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "archaeology::install: download failed"
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

maclib::apps::a::archaeology::update() {
  maclib::apps::a::archaeology::install
}

maclib::apps::a::archaeology::uninstall() {
  maclib::core::log::warn "archaeology::uninstall: no clean uninstall"
  return 1
}
