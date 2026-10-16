#!/usr/bin/env bash
# shellcheck disable=all
# cluefull.sh - Clue (Installomator label) helpers
#
# Vendor source: Installomator label cluefull from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::cluefull::suite_installer_url() {
  # TODO: Add actual download URL for Clue
  printf '%s\\n' 'https://example.com/cluefull/installer'
}

maclib::productivity::cluefull::latest_version() {
  # TODO: Add version detection for Clue
  return 1
}

maclib::productivity::cluefull::is_installed() {
  [[ -d "/Applications/Clue.app" ]] || [[ -d "$HOME/Applications/Clue.app" ]]
}

maclib::productivity::cluefull::installed_path() {
  if [[ -d "/Applications/Clue.app" ]]; then
    printf '%s\\n' "/Applications/Clue.app"
  elif [[ -d "$HOME/Applications/Clue.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Clue.app"
  fi
}

maclib::cluefull::install() {
  local url tmp mp app
  url="$(maclib::cluefull::suite_installer_url)"
  tmp="$(mktemp -d -t "cluefull.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cluefull::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::productivity::cluefull::update() {
  # No vendor update path documented for "Clue".
  maclib::core::log::error "cluefull::update: no update path"
  return 127
}

maclib::productivity::cluefull::uninstall() {
  # No clean uninstall for "Clue" (documented constraint).
  maclib::core::log::error "cluefull::uninstall: no clean uninstall"
  return 1
}
