#!/usr/bin/env bash
# shellcheck disable=all
# creativeforcekelvin.sh - Kelvin (Installomator label) helpers
#
# Vendor source: Installomator label creativeforcekelvin from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::creativeforcekelvin::suite_installer_url() {
  # TODO: Add actual download URL for Kelvin
  printf '%s\\n' 'https://example.com/creativeforcekelvin/installer'
}

maclib::creative::creativeforcekelvin::latest_version() {
  # TODO: Add version detection for Kelvin
  return 1
}

maclib::creative::creativeforcekelvin::is_installed() {
  [[ -d "/Applications/Kelvin.app" ]] || [[ -d "$HOME/Applications/Kelvin.app" ]]
}

maclib::creative::creativeforcekelvin::installed_path() {
  if [[ -d "/Applications/Kelvin.app" ]]; then
    printf '%s\\n' "/Applications/Kelvin.app"
  elif [[ -d "$HOME/Applications/Kelvin.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Kelvin.app"
  fi
}

maclib::creativeforcekelvin::install() {
  local url tmp
  url="$(maclib::creativeforcekelvin::suite_installer_url)"
  tmp="$(mktemp -t "creativeforcekelvin_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "creativeforcekelvin::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::creativeforcekelvin::update() {
  # No vendor update path documented for "Kelvin".
  maclib::core::log::error "creativeforcekelvin::update: no update path"
  return 127
}

maclib::creative::creativeforcekelvin::uninstall() {
  # No clean uninstall for "Kelvin" (documented constraint).
  maclib::core::log::error "creativeforcekelvin::uninstall: no clean uninstall"
  return 1
}
