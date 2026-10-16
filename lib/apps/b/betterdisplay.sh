#!/usr/bin/env bash
# shellcheck disable=all
# betterdisplay.sh - "BetterDisplay" (Installomator label) helpers
#
# Vendor source: Installomator label betterdisplay from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "299YSU96J7".
# Installer type: "dmg".
#

maclib::apps::b::betterdisplay::suite_installer_url() {
  downloadURLFromGit waydabber BetterDisplay
}

maclib::apps::b::betterdisplay::latest_version() {
  versionFromGit waydabber BetterDisplay
}

maclib::apps::b::betterdisplay::is_installed() {
  [[ -d "/Applications/BetterDisplay.app" ]] || [[ -d "$HOME/Applications/BetterDisplay.app" ]]
}

maclib::apps::b::betterdisplay::installed_path() {
  if [[ -d "/Applications/BetterDisplay.app" ]]; then
    printf "%s\n" "/Applications/BetterDisplay.app"
  elif [[ -d "$HOME/Applications/BetterDisplay.app" ]]; then
    printf "%s\n" "$HOME/Applications/BetterDisplay.app"
  fi
}

maclib::apps::b::betterdisplay::install() {
  local url tmp
  url="$(maclib::apps::b::betterdisplay::suite_installer_url)"
  tmp="$(mktemp -d -t "betterdisplay.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "betterdisplay::install: download failed"
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

maclib::apps::b::betterdisplay::update() {
  # No vendor update path documented for "BetterDisplay".
  maclib::core::log::error "betterdisplay::update: no update path"
  return 127
}

maclib::apps::b::betterdisplay::uninstall() {
  # No clean uninstall for "BetterDisplay" (documented constraint).
  maclib::core::log::error "betterdisplay::uninstall: no clean uninstall"
  return 1
}
