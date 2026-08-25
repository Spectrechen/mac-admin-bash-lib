#!/usr/bin/env bash
# shellcheck disable=all
# bravepkg.sh - "Brave Browser" (Installomator label) helpers
#
# Vendor source: Installomator label bravepkg from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "KL8N8XSYF4".
# Installer type: "pkg".
#

maclib::bravepkg::suite_installer_url() {
  "https://referrals.brave.com/latest/Brave-Browser.pkg" # Universal
}

maclib::bravepkg::latest_version() {
  curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2
}

maclib::bravepkg::is_installed() {
  [[ -d "/Applications/BraveBrowser.app" ]] || [[ -d "$HOME/Applications/BraveBrowser.app" ]]
}

maclib::bravepkg::installed_path() {
  if [[ -d "/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "/Applications/BraveBrowser.app"
  elif [[ -d "$HOME/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "$HOME/Applications/BraveBrowser.app"
  fi
}

maclib::bravepkg::install() {
  local url tmp
  url="$(maclib::bravepkg::suite_installer_url)"
  tmp="$(mktemp -d -t "bravepkg.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bravepkg::install: download failed"
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

maclib::bravepkg::update() {
  # No vendor update path documented for "Brave Browser".
  maclib::log::error "bravepkg::update: no update path"
  return 127
}

maclib::bravepkg::uninstall() {
  # No clean uninstall for "Brave Browser" (documented constraint).
  maclib::log::error "bravepkg::uninstall: no clean uninstall"
  return 1
}
