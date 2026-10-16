#!/usr/bin/env bash
# shellcheck disable=all
# daisydisk.sh - DaisyDisk (Installomator label) helpers
#
# Vendor source: Installomator label daisydisk from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::media::daisydisk::suite_installer_url() {
  # TODO: Add actual download URL for DaisyDisk
  printf '%s\\n' 'https://example.com/daisydisk/installer'
}

maclib::media::daisydisk::latest_version() {
  # TODO: Add version detection for DaisyDisk
  return 1
}

maclib::media::daisydisk::is_installed() {
  [[ -d "/Applications/Daisydisk.app" ]] || [[ -d "$HOME/Applications/Daisydisk.app" ]]
}

maclib::media::daisydisk::installed_path() {
  if [[ -d "/Applications/Daisydisk.app" ]]; then
    printf '%s\\n' "/Applications/Daisydisk.app"
  elif [[ -d "$HOME/Applications/Daisydisk.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Daisydisk.app"
  fi
}

maclib::daisydisk::install() {
  local url tmp
  url="$(maclib::daisydisk::suite_installer_url)"
  tmp="$(mktemp -d -t "daisydisk.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "daisydisk::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::media::daisydisk::update() {
  # No vendor update path documented for "DaisyDisk".
  maclib::core::log::error "daisydisk::update: no update path"
  return 127
}

maclib::media::daisydisk::uninstall() {
  # No clean uninstall for "DaisyDisk" (documented constraint).
  maclib::core::log::error "daisydisk::uninstall: no clean uninstall"
  return 1
}
