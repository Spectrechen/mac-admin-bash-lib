#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiorackmode.sh - Rackmode (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiorackmode from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiorackmode::suite_installer_url() {
  # TODO: Add actual download URL for Rackmode
  printf '%s\\n' 'https://example.com/cherryaudiorackmode/installer'
}

maclib::creative::cherryaudiorackmode::latest_version() {
  # TODO: Add version detection for Rackmode
  return 1
}

maclib::creative::cherryaudiorackmode::is_installed() {
  [[ -d "/Applications/Rackmode.app" ]] || [[ -d "$HOME/Applications/Rackmode.app" ]]
}

maclib::creative::cherryaudiorackmode::installed_path() {
  if [[ -d "/Applications/Rackmode.app" ]]; then
    printf '%s\\n' "/Applications/Rackmode.app"
  elif [[ -d "$HOME/Applications/Rackmode.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Rackmode.app"
  fi
}

maclib::cherryaudiorackmode::install() {
  local url tmp
  url="$(maclib::cherryaudiorackmode::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiorackmode_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiorackmode::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiorackmode::update() {
  # No vendor update path documented for "Rackmode".
  maclib::core::log::error "cherryaudiorackmode::update: no update path"
  return 127
}

maclib::creative::cherryaudiorackmode::uninstall() {
  # No clean uninstall for "Rackmode" (documented constraint).
  maclib::core::log::error "cherryaudiorackmode::uninstall: no clean uninstall"
  return 1
}
