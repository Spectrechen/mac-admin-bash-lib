#!/usr/bin/env bash
# shellcheck disable=all
# brave.sh - "Brave Browser" (Installomator label) helpers
#
# Vendor source: Installomator label brave from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "KL8N8XSYF4".
# Installer type: "dmg".
#

maclib::brave::suite_installer_url() {
  downloadURLFromGit brave brave-browser
}

maclib::brave::latest_version() {
  versionFromGit brave brave-browser | sed 's/\.//'
}

maclib::brave::is_installed() {
  [[ -d "/Applications/BraveBrowser.app" ]] || [[ -d "$HOME/Applications/BraveBrowser.app" ]]
}

maclib::brave::installed_path() {
  if [[ -d "/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "/Applications/BraveBrowser.app"
  elif [[ -d "$HOME/Applications/BraveBrowser.app" ]]; then
    printf "%s\n" "$HOME/Applications/BraveBrowser.app"
  fi
}

maclib::brave::install() {
  local url tmp
  url="$(maclib::brave::suite_installer_url)"
  tmp="$(mktemp -d -t "brave.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "brave::install: download failed"
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

maclib::brave::update() {
  # No vendor update path documented for "Brave Browser".
  maclib::log::error "brave::update: no update path"
  return 127
}

maclib::brave::uninstall() {
  # No clean uninstall for "Brave Browser" (documented constraint).
  maclib::log::error "brave::uninstall: no clean uninstall"
  return 1
}
