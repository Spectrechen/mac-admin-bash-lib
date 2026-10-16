#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiominiverse.sh - Miniverse (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiominiverse from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiominiverse::suite_installer_url() {
  # TODO: Add actual download URL for Miniverse
  printf '%s\\n' 'https://example.com/cherryaudiominiverse/installer'
}

maclib::creative::cherryaudiominiverse::latest_version() {
  # TODO: Add version detection for Miniverse
  return 1
}

maclib::creative::cherryaudiominiverse::is_installed() {
  [[ -d "/Applications/Miniverse.app" ]] || [[ -d "$HOME/Applications/Miniverse.app" ]]
}

maclib::creative::cherryaudiominiverse::installed_path() {
  if [[ -d "/Applications/Miniverse.app" ]]; then
    printf '%s\\n' "/Applications/Miniverse.app"
  elif [[ -d "$HOME/Applications/Miniverse.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Miniverse.app"
  fi
}

maclib::cherryaudiominiverse::install() {
  local url tmp
  url="$(maclib::cherryaudiominiverse::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiominiverse_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiominiverse::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiominiverse::update() {
  # No vendor update path documented for "Miniverse".
  maclib::core::log::error "cherryaudiominiverse::update: no update path"
  return 127
}

maclib::creative::cherryaudiominiverse::uninstall() {
  # No clean uninstall for "Miniverse" (documented constraint).
  maclib::core::log::error "cherryaudiominiverse::uninstall: no clean uninstall"
  return 1
}
