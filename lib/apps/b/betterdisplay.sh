#!/usr/bin/env bash
# shellcheck disable=all
# betterdisplay.sh - "BetterDisplay" (Installomator label) helpers
#
# Vendor source: Installomator label betterdisplay from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "299YSU96J7".
# Installer type: "dmg".
#

maclib::betterdisplay::suite_installer_url() {
  downloadURLFromGit waydabber BetterDisplay
}

maclib::betterdisplay::latest_version() {
  versionFromGit waydabber BetterDisplay
}

maclib::betterdisplay::is_installed() {
  [[ -d "/Applications/BetterDisplay.app" ]] || [[ -d "$HOME/Applications/BetterDisplay.app" ]]
}

maclib::betterdisplay::installed_path() {
  if [[ -d "/Applications/BetterDisplay.app" ]]; then
    printf "%s\n" "/Applications/BetterDisplay.app"
  elif [[ -d "$HOME/Applications/BetterDisplay.app" ]]; then
    printf "%s\n" "$HOME/Applications/BetterDisplay.app"
  fi
}

maclib::betterdisplay::install() {
  local url tmp
  url="$(maclib::betterdisplay::suite_installer_url)"
  tmp="$(mktemp -d -t "betterdisplay.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "betterdisplay::install: download failed"
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

maclib::betterdisplay::update() {
  # No vendor update path documented for "BetterDisplay".
  maclib::log::error "betterdisplay::update: no update path"
  return 127
}

maclib::betterdisplay::uninstall() {
  # No clean uninstall for "BetterDisplay" (documented constraint).
  maclib::log::error "betterdisplay::uninstall: no clean uninstall"
  return 1
}
