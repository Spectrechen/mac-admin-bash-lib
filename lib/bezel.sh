#!/usr/bin/env bash
# shellcheck disable=all
# bezel.sh - "Bezel" (Installomator label) helpers
#
# Vendor source: Installomator label bezel from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "WT5N9FK54M".
# Installer type: "dmg".
#

maclib::bezel::suite_installer_url() {
  https://download.nonstrict.eu/bezel/Bezel.dmg
}

maclib::bezel::latest_version() {
  curl -fs "https://download.nonstrict.eu/bezel/appcast.xml" | grep -o '<sparkle:shortVersionString>[^<]*</sparkle:shortVersionString>' | sed -E 's/<[^>]+>//g' | grep -vi 'beta' | head -1
}

maclib::bezel::is_installed() {
  [[ -d "/Applications/Bezel.app" ]] || [[ -d "$HOME/Applications/Bezel.app" ]]
}

maclib::bezel::installed_path() {
  if [[ -d "/Applications/Bezel.app" ]]; then
    printf "%s\n" "/Applications/Bezel.app"
  elif [[ -d "$HOME/Applications/Bezel.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bezel.app"
  fi
}

maclib::bezel::install() {
  local url tmp
  url="$(maclib::bezel::suite_installer_url)"
  tmp="$(mktemp -d -t "bezel.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bezel::install: download failed"
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

maclib::bezel::update() {
  # No vendor update path documented for "Bezel".
  maclib::log::error "bezel::update: no update path"
  return 127
}

maclib::bezel::uninstall() {
  # No clean uninstall for "Bezel" (documented constraint).
  maclib::log::error "bezel::uninstall: no clean uninstall"
  return 1
}
