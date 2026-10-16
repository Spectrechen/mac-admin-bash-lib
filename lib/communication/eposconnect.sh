#!/usr/bin/env bash
# shellcheck disable=all
# eposconnect.sh - EPOS Connect (Installomator label) helpers
#
# Vendor source: Installomator label eposconnect from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::communication::eposconnect::suite_installer_url() {
  # TODO: Add actual download URL for EPOS Connect
  printf '%s\\n' 'https://example.com/eposconnect/installer'
}

maclib::communication::eposconnect::latest_version() {
  # TODO: Add version detection for EPOS Connect
  return 1
}

maclib::communication::eposconnect::is_installed() {
  [[ -d "/Applications/Epos Connect.app" ]] || [[ -d "$HOME/Applications/Epos Connect.app" ]]
}

maclib::communication::eposconnect::installed_path() {
  if [[ -d "/Applications/Epos Connect.app" ]]; then
    printf '%s\\n' "/Applications/Epos Connect.app"
  elif [[ -d "$HOME/Applications/Epos Connect.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Epos Connect.app"
  fi
}

maclib::eposconnect::install() {
  local url tmp
  url="$(maclib::eposconnect::suite_installer_url)"
  tmp="$(mktemp -t "eposconnect_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eposconnect::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::communication::eposconnect::update() {
  # No vendor update path documented for "EPOS Connect".
  maclib::core::log::error "eposconnect::update: no update path"
  return 127
}

maclib::communication::eposconnect::uninstall() {
  # No clean uninstall for "EPOS Connect" (documented constraint).
  maclib::core::log::error "eposconnect::uninstall: no clean uninstall"
  return 1
}
