#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioquadra.sh - Quadra (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioquadra from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudioquadra::suite_installer_url() {
  # TODO: Add actual download URL for Quadra
  printf '%s\\n' 'https://example.com/cherryaudioquadra/installer'
}

maclib::creative::cherryaudioquadra::latest_version() {
  # TODO: Add version detection for Quadra
  return 1
}

maclib::creative::cherryaudioquadra::is_installed() {
  [[ -d "/Applications/Quadra.app" ]] || [[ -d "$HOME/Applications/Quadra.app" ]]
}

maclib::creative::cherryaudioquadra::installed_path() {
  if [[ -d "/Applications/Quadra.app" ]]; then
    printf '%s\\n' "/Applications/Quadra.app"
  elif [[ -d "$HOME/Applications/Quadra.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Quadra.app"
  fi
}

maclib::cherryaudioquadra::install() {
  local url tmp
  url="$(maclib::cherryaudioquadra::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudioquadra_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudioquadra::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudioquadra::update() {
  # No vendor update path documented for "Quadra".
  maclib::core::log::error "cherryaudioquadra::update: no update path"
  return 127
}

maclib::creative::cherryaudioquadra::uninstall() {
  # No clean uninstall for "Quadra" (documented constraint).
  maclib::core::log::error "cherryaudioquadra::uninstall: no clean uninstall"
  return 1
}
