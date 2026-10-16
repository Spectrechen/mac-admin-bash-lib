#!/usr/bin/env bash
# shellcheck disable=all
# editshare-connect.sh - EditShare Connect (Installomator label) helpers
#
# Vendor source: Installomator label editshare-connect from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::editshare-connect::suite_installer_url() {
  # TODO: Add actual download URL for EditShare Connect
  printf '%s\\n' 'https://example.com/editshare-connect/installer'
}

maclib::cloud_storage::editshare-connect::latest_version() {
  # TODO: Add version detection for EditShare Connect
  return 1
}

maclib::cloud_storage::editshare-connect::is_installed() {
  [[ -d "/Applications/Editshare Connect.app" ]] || [[ -d "$HOME/Applications/Editshare Connect.app" ]]
}

maclib::cloud_storage::editshare-connect::installed_path() {
  if [[ -d "/Applications/Editshare Connect.app" ]]; then
    printf '%s\\n' "/Applications/Editshare Connect.app"
  elif [[ -d "$HOME/Applications/Editshare Connect.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Editshare Connect.app"
  fi
}

maclib::editshare-connect::install() {
  local url tmp
  url="$(maclib::editshare-connect::suite_installer_url)"
  tmp="$(mktemp -t "editshare-connect_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "editshare-connect::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::editshare-connect::update() {
  # No vendor update path documented for "EditShare Connect".
  maclib::core::log::error "editshare-connect::update: no update path"
  return 127
}

maclib::cloud_storage::editshare-connect::uninstall() {
  # No clean uninstall for "EditShare Connect" (documented constraint).
  maclib::core::log::error "editshare-connect::uninstall: no clean uninstall"
  return 1
}
