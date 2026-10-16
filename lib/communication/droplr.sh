#!/usr/bin/env bash
# shellcheck disable=all
# droplr.sh - Droplr (Installomator label) helpers
#
# Vendor source: Installomator label droplr from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::communication::droplr::suite_installer_url() {
  # TODO: Add actual download URL for Droplr
  printf '%s\\n' 'https://example.com/droplr/installer'
}

maclib::communication::droplr::latest_version() {
  # TODO: Add version detection for Droplr
  return 1
}

maclib::communication::droplr::is_installed() {
  [[ -d "/Applications/Droplr.app" ]] || [[ -d "$HOME/Applications/Droplr.app" ]]
}

maclib::communication::droplr::installed_path() {
  if [[ -d "/Applications/Droplr.app" ]]; then
    printf '%s\\n' "/Applications/Droplr.app"
  elif [[ -d "$HOME/Applications/Droplr.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Droplr.app"
  fi
}

maclib::droplr::install() {
  local url tmp mp app
  url="$(maclib::droplr::suite_installer_url)"
  tmp="$(mktemp -d -t "droplr.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "droplr::install: download failed"
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


maclib::communication::droplr::update() {
  # No vendor update path documented for "Droplr".
  maclib::core::log::error "droplr::update: no update path"
  return 127
}

maclib::communication::droplr::uninstall() {
  # No clean uninstall for "Droplr" (documented constraint).
  maclib::core::log::error "droplr::uninstall: no clean uninstall"
  return 1
}
