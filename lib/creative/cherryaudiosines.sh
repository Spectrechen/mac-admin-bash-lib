#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosines.sh - Sines (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosines from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiosines::suite_installer_url() {
  # TODO: Add actual download URL for Sines
  printf '%s\\n' 'https://example.com/cherryaudiosines/installer'
}

maclib::creative::cherryaudiosines::latest_version() {
  # TODO: Add version detection for Sines
  return 1
}

maclib::creative::cherryaudiosines::is_installed() {
  [[ -d "/Applications/Sines.app" ]] || [[ -d "$HOME/Applications/Sines.app" ]]
}

maclib::creative::cherryaudiosines::installed_path() {
  if [[ -d "/Applications/Sines.app" ]]; then
    printf '%s\\n' "/Applications/Sines.app"
  elif [[ -d "$HOME/Applications/Sines.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Sines.app"
  fi
}

maclib::cherryaudiosines::install() {
  local url tmp
  url="$(maclib::cherryaudiosines::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiosines_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosines::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiosines::update() {
  # No vendor update path documented for "Sines".
  maclib::core::log::error "cherryaudiosines::update: no update path"
  return 127
}

maclib::creative::cherryaudiosines::uninstall() {
  # No clean uninstall for "Sines" (documented constraint).
  maclib::core::log::error "cherryaudiosines::uninstall: no clean uninstall"
  return 1
}
