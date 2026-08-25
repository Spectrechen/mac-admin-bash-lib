#!/usr/bin/env bash
# shellcheck disable=all
# cakebrew.sh - "Cakebrew" (Installomator label) helpers
#
# Vendor source: Installomator label cakebrew from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "R85D3K8ATT".
# Installer type: "zip".
#

maclib::cakebrew::suite_installer_url() {
  curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@url' 2>/dev/null | cut -d '"' -f 2
}

maclib::cakebrew::latest_version() {
  curl -fsL "https://www.cakebrew.com/appcast/profileInfo.php" | xpath '//rss/channel/item[1]/enclosure/@sparkle:shortVersionString' 2>/dev/null | cut -d '"' -f 2
}

maclib::cakebrew::is_installed() {
  [[ -d "/Applications/Cakebrew.app" ]] || [[ -d "$HOME/Applications/Cakebrew.app" ]]
}

maclib::cakebrew::installed_path() {
  if [[ -d "/Applications/Cakebrew.app" ]]; then
    printf "%s\n" "/Applications/Cakebrew.app"
  elif [[ -d "$HOME/Applications/Cakebrew.app" ]]; then
    printf "%s\n" "$HOME/Applications/Cakebrew.app"
  fi
}

maclib::cakebrew::install() {
  local url tmp
  url="$(maclib::cakebrew::suite_installer_url)"
  tmp="$(mktemp -d -t "cakebrew.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cakebrew::install: download failed"
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

maclib::cakebrew::update() {
  # No vendor update path documented for "Cakebrew".
  maclib::log::error "cakebrew::update: no update path"
  return 127
}

maclib::cakebrew::uninstall() {
  # No clean uninstall for "Cakebrew" (documented constraint).
  maclib::log::error "cakebrew::uninstall: no clean uninstall"
  return 1
}
