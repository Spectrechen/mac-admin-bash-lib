#!/usr/bin/env bash
# shellcheck disable=all
# bravepkg.sh - "Brave Browser" (Installomator label) helpers
#
# Vendor source: Installomator label bravepkg from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "KL8N8XSYF4".
# Installer type: "pkg".
#

maclib::apps::b::bravepkg::suite_installer_url() {
  "https://referrals.brave.com/latest/Brave-Browser.pkg" # Universal
}

maclib::apps::b::bravepkg::latest_version() {
  curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null | cut -d '"' -f 2
}

maclib::apps::b::bravepkg::is_installed() {
  [[ -d "/Applications/BraveBrowser.app" ]] || [[ -d "$HOME/Applications/BraveBrowser.app" ]]
}

maclib::apps::b::bravepkg::installed_path() {
  if [[ -d "/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "/Applications/BraveBrowser.app"
  elif [[ -d "$HOME/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "$HOME/Applications/BraveBrowser.app"
  fi
}

maclib::apps::b::bravepkg::install() {
  local url tmp
  url="$(maclib::apps::b::bravepkg::suite_installer_url)"
  tmp="$(mktemp -d -t "bravepkg.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "bravepkg::install: download failed"
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

maclib::apps::b::bravepkg::update() {
  # No vendor update path documented for "Brave Browser".
  maclib::core::log::error "bravepkg::update: no update path"
  return 127
}

maclib::apps::b::bravepkg::uninstall() {
  # No clean uninstall for "Brave Browser" (documented constraint).
  maclib::core::log::error "bravepkg::uninstall: no clean uninstall"
  return 1
}
