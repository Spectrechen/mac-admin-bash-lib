#!/usr/bin/env bash
# shellcheck disable=all
# desktoppr.sh - desktoppr (Installomator label) helpers
#
# Vendor source: Installomator label desktoppr from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::mdm::desktoppr::suite_installer_url() {
  # TODO: Add actual download URL for desktoppr
  printf '%s\\n' 'https://example.com/desktoppr/installer'
}

maclib::mdm::desktoppr::latest_version() {
  # TODO: Add version detection for desktoppr
  return 1
}

maclib::mdm::desktoppr::is_installed() {
  [[ -d "/Applications/Desktoppr.app" ]] || [[ -d "$HOME/Applications/Desktoppr.app" ]]
}

maclib::mdm::desktoppr::installed_path() {
  if [[ -d "/Applications/Desktoppr.app" ]]; then
    printf '%s\\n' "/Applications/Desktoppr.app"
  elif [[ -d "$HOME/Applications/Desktoppr.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Desktoppr.app"
  fi
}

maclib::desktoppr::install() {
  local url tmp
  url="$(maclib::desktoppr::suite_installer_url)"
  tmp="$(mktemp -t "desktoppr_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "desktoppr::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::mdm::desktoppr::update() {
  # No vendor update path documented for "desktoppr".
  maclib::core::log::error "desktoppr::update: no update path"
  return 127
}

maclib::mdm::desktoppr::uninstall() {
  # No clean uninstall for "desktoppr" (documented constraint).
  maclib::core::log::error "desktoppr::uninstall: no clean uninstall"
  return 1
}
