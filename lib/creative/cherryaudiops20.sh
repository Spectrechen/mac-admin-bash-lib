#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiops20.sh - PS-20 (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiops20 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiops20::suite_installer_url() {
  # TODO: Add actual download URL for PS-20
  printf '%s\\n' 'https://example.com/cherryaudiops20/installer'
}

maclib::creative::cherryaudiops20::latest_version() {
  # TODO: Add version detection for PS-20
  return 1
}

maclib::creative::cherryaudiops20::is_installed() {
  [[ -d "/Applications/Ps-20.app" ]] || [[ -d "$HOME/Applications/Ps-20.app" ]]
}

maclib::creative::cherryaudiops20::installed_path() {
  if [[ -d "/Applications/Ps-20.app" ]]; then
    printf '%s\\n' "/Applications/Ps-20.app"
  elif [[ -d "$HOME/Applications/Ps-20.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ps-20.app"
  fi
}

maclib::cherryaudiops20::install() {
  local url tmp
  url="$(maclib::cherryaudiops20::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiops20_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiops20::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiops20::update() {
  # No vendor update path documented for "PS-20".
  maclib::core::log::error "cherryaudiops20::update: no update path"
  return 127
}

maclib::creative::cherryaudiops20::uninstall() {
  # No clean uninstall for "PS-20" (documented constraint).
  maclib::core::log::error "cherryaudiops20::uninstall: no clean uninstall"
  return 1
}
