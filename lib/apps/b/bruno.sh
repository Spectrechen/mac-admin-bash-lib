#!/usr/bin/env bash
# shellcheck disable=all
# bruno.sh - "Bruno" (Installomator label) helpers
#
# Vendor source: Installomator label bruno from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "P3WTZH48ZB".
# Installer type: "dmg".
#

maclib::bruno::suite_installer_url() {
  downloadURLFromGit usebruno bruno
}

maclib::bruno::latest_version() {
  versionFromGit usebruno bruno
}

maclib::bruno::is_installed() {
  [[ -d "/Applications/Bruno.app" ]] || [[ -d "$HOME/Applications/Bruno.app" ]]
}

maclib::bruno::installed_path() {
  if [[ -d "/Applications/Bruno.app" ]]; then
    printf "%s\n" "/Applications/Bruno.app"
  elif [[ -d "$HOME/Applications/Bruno.app" ]]; then
    printf "%s\n" "$HOME/Applications/Bruno.app"
  fi
}

maclib::bruno::install() {
  local url tmp
  url="$(maclib::bruno::suite_installer_url)"
  tmp="$(mktemp -d -t "bruno.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bruno::install: download failed"
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

maclib::bruno::update() {
  # No vendor update path documented for "Bruno".
  maclib::log::error "bruno::update: no update path"
  return 127
}

maclib::bruno::uninstall() {
  # No clean uninstall for "Bruno" (documented constraint).
  maclib::log::error "bruno::uninstall: no clean uninstall"
  return 1
}
