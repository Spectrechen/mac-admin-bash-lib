#!/usr/bin/env bash
# shellcheck disable=all
# egnyte.sh - Egnyte Connect (Installomator label) helpers
#
# Vendor source: Installomator label egnyte from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::egnyte::suite_installer_url() {
  # TODO: Add actual download URL for Egnyte Connect
  printf '%s\\n' 'https://example.com/egnyte/installer'
}

maclib::cloud_storage::egnyte::latest_version() {
  # TODO: Add version detection for Egnyte Connect
  return 1
}

maclib::cloud_storage::egnyte::is_installed() {
  [[ -d "/Applications/Egnyte Connect.app" ]] || [[ -d "$HOME/Applications/Egnyte Connect.app" ]]
}

maclib::cloud_storage::egnyte::installed_path() {
  if [[ -d "/Applications/Egnyte Connect.app" ]]; then
    printf '%s\\n' "/Applications/Egnyte Connect.app"
  elif [[ -d "$HOME/Applications/Egnyte Connect.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Egnyte Connect.app"
  fi
}

maclib::egnyte::install() {
  local url tmp
  url="$(maclib::egnyte::suite_installer_url)"
  tmp="$(mktemp -t "egnyte_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "egnyte::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::egnyte::update() {
  # No vendor update path documented for "Egnyte Connect".
  maclib::core::log::error "egnyte::update: no update path"
  return 127
}

maclib::cloud_storage::egnyte::uninstall() {
  # No clean uninstall for "Egnyte Connect" (documented constraint).
  maclib::core::log::error "egnyte::uninstall: no clean uninstall"
  return 1
}
