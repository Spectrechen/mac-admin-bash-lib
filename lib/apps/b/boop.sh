#!/usr/bin/env bash
# shellcheck disable=all
# boop.sh - "Boop" (Installomator label) helpers
#
# Vendor source: Installomator label boop from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "RLZ8XBTX7G".
# Installer type: "zip".
#

maclib::apps::b::boop::suite_installer_url() {
  downloadURLFromGit IvanMathy Boop
}

maclib::apps::b::boop::latest_version() {
  versionFromGit IvanMathy Boop
}

maclib::apps::b::boop::is_installed() {
  [[ -d "/Applications/Boop.app" ]] || [[ -d "$HOME/Applications/Boop.app" ]]
}

maclib::apps::b::boop::installed_path() {
  if [[ -d "/Applications/Boop.app" ]]; then
    printf "%s\n" "/Applications/Boop.app"
  elif [[ -d "$HOME/Applications/Boop.app" ]]; then
    printf "%s\n" "$HOME/Applications/Boop.app"
  fi
}

maclib::apps::b::boop::install() {
  local url tmp
  url="$(maclib::apps::b::boop::suite_installer_url)"
  tmp="$(mktemp -d -t "boop.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "boop::install: download failed"
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

maclib::apps::b::boop::update() {
  # No vendor update path documented for "Boop".
  maclib::core::log::error "boop::update: no update path"
  return 127
}

maclib::apps::b::boop::uninstall() {
  # No clean uninstall for "Boop" (documented constraint).
  maclib::core::log::error "boop::uninstall: no clean uninstall"
  return 1
}
