#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosolovox.sh - Solovox (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosolovox from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiosolovox::suite_installer_url() {
  # TODO: Add actual download URL for Solovox
  printf '%s\\n' 'https://example.com/cherryaudiosolovox/installer'
}

maclib::creative::cherryaudiosolovox::latest_version() {
  # TODO: Add version detection for Solovox
  return 1
}

maclib::creative::cherryaudiosolovox::is_installed() {
  [[ -d "/Applications/Solovox.app" ]] || [[ -d "$HOME/Applications/Solovox.app" ]]
}

maclib::creative::cherryaudiosolovox::installed_path() {
  if [[ -d "/Applications/Solovox.app" ]]; then
    printf '%s\\n' "/Applications/Solovox.app"
  elif [[ -d "$HOME/Applications/Solovox.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Solovox.app"
  fi
}

maclib::cherryaudiosolovox::install() {
  local url tmp
  url="$(maclib::cherryaudiosolovox::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiosolovox_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosolovox::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiosolovox::update() {
  # No vendor update path documented for "Solovox".
  maclib::core::log::error "cherryaudiosolovox::update: no update path"
  return 127
}

maclib::creative::cherryaudiosolovox::uninstall() {
  # No clean uninstall for "Solovox" (documented constraint).
  maclib::core::log::error "cherryaudiosolovox::uninstall: no clean uninstall"
  return 1
}
