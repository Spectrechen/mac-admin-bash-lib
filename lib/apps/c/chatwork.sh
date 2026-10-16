#!/usr/bin/env bash
# shellcheck disable=all
# chatwork.sh - "Chatwork" (Installomator label) helpers
#
# Vendor source: Installomator label chatwork from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "H34A3H2Y54".
# Installer type: "dmg".
#

maclib::apps::c::chatwork::suite_installer_url() {
  printf '%s\n' 'https://desktop-app.chatwork.com/installer/Chatwork.dmg'
}

maclib::apps::c::chatwork::latest_version() {
  printf '%s\n' ''
}

maclib::apps::c::chatwork::is_installed() {
  [[ -d "/Applications/Chatwork.app" ]] || [[ -d "$HOME/Applications/Chatwork.app" ]]
}

maclib::apps::c::chatwork::installed_path() {
  if [[ -d "/Applications/Chatwork.app" ]]; then
    printf "%s\n" "/Applications/Chatwork.app"
  elif [[ -d "$HOME/Applications/Chatwork.app" ]]; then
    printf "%s\n" "$HOME/Applications/Chatwork.app"
  fi
}

maclib::apps::c::chatwork::install() {
  local url tmp
  url="$(maclib::apps::c::chatwork::suite_installer_url)"
  tmp="$(mktemp -d -t "chatwork.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "chatwork::install: download failed"
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

maclib::apps::c::chatwork::update() {
  # No vendor update path documented for "Chatwork".
  maclib::core::log::error "chatwork::update: no update path"
  return 127
}

maclib::apps::c::chatwork::uninstall() {
  # No clean uninstall for "Chatwork" (documented constraint).
  maclib::core::log::error "chatwork::uninstall: no clean uninstall"
  return 1
}
