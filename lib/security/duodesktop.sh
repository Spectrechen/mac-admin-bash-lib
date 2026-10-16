#!/usr/bin/env bash
# shellcheck disable=all
# duodesktop.sh - Duo Desktop (Installomator label) helpers
#
# Vendor source: Installomator label duodesktop from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::security::duodesktop::suite_installer_url() {
  # TODO: Add actual download URL for Duo Desktop
  printf '%s\\n' 'https://example.com/duodesktop/installer'
}

maclib::security::duodesktop::latest_version() {
  # TODO: Add version detection for Duo Desktop
  return 1
}

maclib::security::duodesktop::is_installed() {
  [[ -d "/Applications/Duo Desktop.app" ]] || [[ -d "$HOME/Applications/Duo Desktop.app" ]]
}

maclib::security::duodesktop::installed_path() {
  if [[ -d "/Applications/Duo Desktop.app" ]]; then
    printf '%s\\n' "/Applications/Duo Desktop.app"
  elif [[ -d "$HOME/Applications/Duo Desktop.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Duo Desktop.app"
  fi
}

maclib::duodesktop::install() {
  local url tmp
  url="$(maclib::duodesktop::suite_installer_url)"
  tmp="$(mktemp -t "duodesktop_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "duodesktop::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::security::duodesktop::update() {
  # No vendor update path documented for "Duo Desktop".
  maclib::core::log::error "duodesktop::update: no update path"
  return 127
}

maclib::security::duodesktop::uninstall() {
  # No clean uninstall for "Duo Desktop" (documented constraint).
  maclib::core::log::error "duodesktop::uninstall: no clean uninstall"
  return 1
}
