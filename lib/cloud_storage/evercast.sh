#!/usr/bin/env bash
# shellcheck disable=all
# evercast.sh - Evercast (Installomator label) helpers
#
# Vendor source: Installomator label evercast from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::evercast::suite_installer_url() {
  # TODO: Add actual download URL for Evercast
  printf '%s\\n' 'https://example.com/evercast/installer'
}

maclib::cloud_storage::evercast::latest_version() {
  # TODO: Add version detection for Evercast
  return 1
}

maclib::cloud_storage::evercast::is_installed() {
  [[ -d "/Applications/Evercast.app" ]] || [[ -d "$HOME/Applications/Evercast.app" ]]
}

maclib::cloud_storage::evercast::installed_path() {
  if [[ -d "/Applications/Evercast.app" ]]; then
    printf '%s\\n' "/Applications/Evercast.app"
  elif [[ -d "$HOME/Applications/Evercast.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Evercast.app"
  fi
}

maclib::evercast::install() {
  local url tmp
  url="$(maclib::evercast::suite_installer_url)"
  tmp="$(mktemp -t "evercast_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "evercast::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::evercast::update() {
  # No vendor update path documented for "Evercast".
  maclib::core::log::error "evercast::update: no update path"
  return 127
}

maclib::cloud_storage::evercast::uninstall() {
  # No clean uninstall for "Evercast" (documented constraint).
  maclib::core::log::error "evercast::uninstall: no clean uninstall"
  return 1
}
