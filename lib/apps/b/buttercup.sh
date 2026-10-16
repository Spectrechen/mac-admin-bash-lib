#!/usr/bin/env bash
# shellcheck disable=all
# buttercup.sh - "Buttercup" (Installomator label) helpers
#
# Vendor source: Installomator label buttercup from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "9D8F4J769D".
# Installer type: "zip".
#

maclib::apps::b::buttercup::suite_installer_url() {
  downloadURLFromGit buttercup buttercup-desktop
}

maclib::apps::b::buttercup::latest_version() {
  versionFromGit buttercup buttercup-desktop
}

maclib::apps::b::buttercup::is_installed() {
  [[ -d "/Applications/Buttercup.app" ]] || [[ -d "$HOME/Applications/Buttercup.app" ]]
}

maclib::apps::b::buttercup::installed_path() {
  if [[ -d "/Applications/Buttercup.app" ]]; then
    printf "%s\n" "/Applications/Buttercup.app"
  elif [[ -d "$HOME/Applications/Buttercup.app" ]]; then
    printf "%s\n" "$HOME/Applications/Buttercup.app"
  fi
}

maclib::apps::b::buttercup::install() {
  local url tmp
  url="$(maclib::apps::b::buttercup::suite_installer_url)"
  tmp="$(mktemp -d -t "buttercup.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "buttercup::install: download failed"
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

maclib::apps::b::buttercup::update() {
  # No vendor update path documented for "Buttercup".
  maclib::core::log::error "buttercup::update: no update path"
  return 127
}

maclib::apps::b::buttercup::uninstall() {
  # No clean uninstall for "Buttercup" (documented constraint).
  maclib::core::log::error "buttercup::uninstall: no clean uninstall"
  return 1
}
