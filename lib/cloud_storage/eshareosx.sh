#!/usr/bin/env bash
# shellcheck disable=all
# eshareosx.sh - e-Share (Installomator label) helpers
#
# Vendor source: Installomator label eshareosx from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::eshareosx::suite_installer_url() {
  # TODO: Add actual download URL for e-Share
  printf '%s\\n' 'https://example.com/eshareosx/installer'
}

maclib::cloud_storage::eshareosx::latest_version() {
  # TODO: Add version detection for e-Share
  return 1
}

maclib::cloud_storage::eshareosx::is_installed() {
  [[ -d "/Applications/E-Share.app" ]] || [[ -d "$HOME/Applications/E-Share.app" ]]
}

maclib::cloud_storage::eshareosx::installed_path() {
  if [[ -d "/Applications/E-Share.app" ]]; then
    printf '%s\\n' "/Applications/E-Share.app"
  elif [[ -d "$HOME/Applications/E-Share.app" ]]; then
    printf '%s\\n' "$HOME/Applications/E-Share.app"
  fi
}

maclib::eshareosx::install() {
  local url tmp
  url="$(maclib::eshareosx::suite_installer_url)"
  tmp="$(mktemp -t "eshareosx_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eshareosx::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::eshareosx::update() {
  # No vendor update path documented for "e-Share".
  maclib::core::log::error "eshareosx::update: no update path"
  return 127
}

maclib::cloud_storage::eshareosx::uninstall() {
  # No clean uninstall for "e-Share" (documented constraint).
  maclib::core::log::error "eshareosx::uninstall: no clean uninstall"
  return 1
}
