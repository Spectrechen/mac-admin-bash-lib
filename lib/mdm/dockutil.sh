#!/usr/bin/env bash
# shellcheck disable=all
# dockutil.sh - dockutil (Installomator label) helpers
#
# Vendor source: Installomator label dockutil from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::mdm::dockutil::suite_installer_url() {
  # TODO: Add actual download URL for dockutil
  printf '%s\\n' 'https://example.com/dockutil/installer'
}

maclib::mdm::dockutil::latest_version() {
  # TODO: Add version detection for dockutil
  return 1
}

maclib::mdm::dockutil::is_installed() {
  [[ -d "/Applications/Dockutil.app" ]] || [[ -d "$HOME/Applications/Dockutil.app" ]]
}

maclib::mdm::dockutil::installed_path() {
  if [[ -d "/Applications/Dockutil.app" ]]; then
    printf '%s\\n' "/Applications/Dockutil.app"
  elif [[ -d "$HOME/Applications/Dockutil.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dockutil.app"
  fi
}

maclib::dockutil::install() {
  local url tmp
  url="$(maclib::dockutil::suite_installer_url)"
  tmp="$(mktemp -t "dockutil_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "dockutil::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::mdm::dockutil::update() {
  # No vendor update path documented for "dockutil".
  maclib::core::log::error "dockutil::update: no update path"
  return 127
}

maclib::mdm::dockutil::uninstall() {
  # No clean uninstall for "dockutil" (documented constraint).
  maclib::core::log::error "dockutil::uninstall: no clean uninstall"
  return 1
}
