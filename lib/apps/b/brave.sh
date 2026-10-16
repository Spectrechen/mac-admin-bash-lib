#!/usr/bin/env bash
# shellcheck disable=all
# brave.sh - "Brave Browser" (Installomator label) helpers
#
# Vendor source: Installomator label brave from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "KL8N8XSYF4".
# Installer type: "dmg".
#

maclib::apps::b::brave::suite_installer_url() {
  downloadURLFromGit brave brave-browser
}

maclib::apps::b::brave::latest_version() {
  versionFromGit brave brave-browser | sed 's/\.//'
}

maclib::apps::b::brave::is_installed() {
  [[ -d "/Applications/BraveBrowser.app" ]] || [[ -d "$HOME/Applications/BraveBrowser.app" ]]
}

maclib::apps::b::brave::installed_path() {
  if [[ -d "/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "/Applications/BraveBrowser.app"
  elif [[ -d "$HOME/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "$HOME/Applications/BraveBrowser.app"
  fi
}

maclib::apps::b::brave::install() {
  local url tmp
  url="$(maclib::apps::b::brave::suite_installer_url)"
  tmp="$(mktemp -d -t "brave.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "brave::install: download failed"
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

maclib::apps::b::brave::update() {
  # No vendor update path documented for "Brave Browser".
  maclib::core::log::error "brave::update: no update path"
  return 127
}

maclib::apps::b::brave::uninstall() {
  # No clean uninstall for "Brave Browser" (documented constraint).
  maclib::core::log::error "brave::uninstall: no clean uninstall"
  return 1
}
