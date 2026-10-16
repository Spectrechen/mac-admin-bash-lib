#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiops3300.sh - PS-3300 (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiops3300 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiops3300::suite_installer_url() {
  # TODO: Add actual download URL for PS-3300
  printf '%s\\n' 'https://example.com/cherryaudiops3300/installer'
}

maclib::creative::cherryaudiops3300::latest_version() {
  # TODO: Add version detection for PS-3300
  return 1
}

maclib::creative::cherryaudiops3300::is_installed() {
  [[ -d "/Applications/Ps-3300.app" ]] || [[ -d "$HOME/Applications/Ps-3300.app" ]]
}

maclib::creative::cherryaudiops3300::installed_path() {
  if [[ -d "/Applications/Ps-3300.app" ]]; then
    printf '%s\\n' "/Applications/Ps-3300.app"
  elif [[ -d "$HOME/Applications/Ps-3300.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ps-3300.app"
  fi
}

maclib::cherryaudiops3300::install() {
  local url tmp
  url="$(maclib::cherryaudiops3300::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiops3300_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiops3300::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiops3300::update() {
  # No vendor update path documented for "PS-3300".
  maclib::core::log::error "cherryaudiops3300::update: no update path"
  return 127
}

maclib::creative::cherryaudiops3300::uninstall() {
  # No clean uninstall for "PS-3300" (documented constraint).
  maclib::core::log::error "cherryaudiops3300::uninstall: no clean uninstall"
  return 1
}
