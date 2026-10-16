#!/usr/bin/env bash
# shellcheck disable=all
# bugdom.sh - "Bugdom" (Installomator label) helpers
#
# Vendor source: Installomator label bugdom from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "RVNL7XC27G".
# Installer type: "dmg".
#

maclib::apps::b::bugdom::suite_installer_url() {
  downloadURLFromGit jorio Bugdom
}

maclib::apps::b::bugdom::latest_version() {
  versionFromGit jorio Bugdom
}

maclib::apps::b::bugdom::is_installed() {
  [[ -d "/Applications/Bugdom.app" ]] || [[ -d "$HOME/Applications/Bugdom.app" ]]
}

maclib::apps::b::bugdom::installed_path() {
  if [[ -d "/Applications/Bugdom.app" ]]; then
    printf "%s\n" "/Applications/Bugdom.app"
  elif [[ -d "$HOME/Applications/Bugdom.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bugdom.app"
  fi
}

maclib::apps::b::bugdom::install() {
  local url tmp
  url="$(maclib::apps::b::bugdom::suite_installer_url)"
  tmp="$(mktemp -d -t "bugdom.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "bugdom::install: download failed"
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

maclib::apps::b::bugdom::update() {
  # No vendor update path documented for "Bugdom".
  maclib::core::log::error "bugdom::update: no update path"
  return 127
}

maclib::apps::b::bugdom::uninstall() {
  # No clean uninstall for "Bugdom" (documented constraint).
  maclib::core::log::error "bugdom::uninstall: no clean uninstall"
  return 1
}
