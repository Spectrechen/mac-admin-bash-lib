#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiolowdown.sh - Lowdown (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiolowdown from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiolowdown::suite_installer_url() {
  # TODO: Add actual download URL for Lowdown
  printf '%s\\n' 'https://example.com/cherryaudiolowdown/installer'
}

maclib::creative::cherryaudiolowdown::latest_version() {
  # TODO: Add version detection for Lowdown
  return 1
}

maclib::creative::cherryaudiolowdown::is_installed() {
  [[ -d "/Applications/Lowdown.app" ]] || [[ -d "$HOME/Applications/Lowdown.app" ]]
}

maclib::creative::cherryaudiolowdown::installed_path() {
  if [[ -d "/Applications/Lowdown.app" ]]; then
    printf '%s\\n' "/Applications/Lowdown.app"
  elif [[ -d "$HOME/Applications/Lowdown.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Lowdown.app"
  fi
}

maclib::cherryaudiolowdown::install() {
  local url tmp
  url="$(maclib::cherryaudiolowdown::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiolowdown_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiolowdown::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiolowdown::update() {
  # No vendor update path documented for "Lowdown".
  maclib::core::log::error "cherryaudiolowdown::update: no update path"
  return 127
}

maclib::creative::cherryaudiolowdown::uninstall() {
  # No clean uninstall for "Lowdown" (documented constraint).
  maclib::core::log::error "cherryaudiolowdown::uninstall: no clean uninstall"
  return 1
}
