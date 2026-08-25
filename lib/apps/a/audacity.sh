#!/usr/bin/env bash
# shellcheck disable=all
# audacity.sh - "Audacity" (Installomator label) helpers
#
# Vendor source: Installomator label audacity from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "AWEYX923UX".
# Installer type: "dmg".
#

maclib::audacity::suite_installer_url() {
  downloadURLFromGit audacity audacity
}

maclib::audacity::latest_version() {
  versionFromGit audacity audacity
}

maclib::audacity::is_installed() {
  [[ -d "/Applications/Audacity.app" ]] || [[ -d "$HOME/Applications/Audacity.app" ]]
}

maclib::audacity::installed_path() {
  if [[ -d "/Applications/Audacity.app" ]]; then
    printf "%s\n" "/Applications/Audacity.app"
  elif [[ -d "$HOME/Applications/Audacity.app" ]]; then
    printf "%s\n" "$HOME/Applications/Audacity.app"
  fi
}

maclib::audacity::install() {
  local url tmp
  url="$(maclib::audacity::suite_installer_url)"
  tmp="$(mktemp -d -t "audacity.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "audacity::install: download failed"
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

maclib::audacity::update() {
  # No vendor update path documented for "Audacity".
  maclib::log::error "audacity::update: no update path"
  return 127
}

maclib::audacity::uninstall() {
  # No clean uninstall for "Audacity" (documented constraint).
  maclib::log::error "audacity::uninstall: no clean uninstall"
  return 1
}
