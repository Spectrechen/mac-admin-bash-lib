#!/usr/bin/env bash
# shellcheck disable=all
# expressvpn.sh - ExpressVPN (Installomator label) helpers
#
# Vendor source: Installomator label expressvpn from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::security::expressvpn::suite_installer_url() {
  # TODO: Add actual download URL for ExpressVPN
  printf '%s\\n' 'https://example.com/expressvpn/installer'
}

maclib::security::expressvpn::latest_version() {
  # TODO: Add version detection for ExpressVPN
  return 1
}

maclib::security::expressvpn::is_installed() {
  [[ -d "/Applications/Expressvpn.app" ]] || [[ -d "$HOME/Applications/Expressvpn.app" ]]
}

maclib::security::expressvpn::installed_path() {
  if [[ -d "/Applications/Expressvpn.app" ]]; then
    printf '%s\\n' "/Applications/Expressvpn.app"
  elif [[ -d "$HOME/Applications/Expressvpn.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Expressvpn.app"
  fi
}

maclib::expressvpn::install() {
  local url tmp
  url="$(maclib::expressvpn::suite_installer_url)"
  tmp="$(mktemp -t "expressvpn_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "expressvpn::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::security::expressvpn::update() {
  # No vendor update path documented for "ExpressVPN".
  maclib::core::log::error "expressvpn::update: no update path"
  return 127
}

maclib::security::expressvpn::uninstall() {
  # No clean uninstall for "ExpressVPN" (documented constraint).
  maclib::core::log::error "expressvpn::uninstall: no clean uninstall"
  return 1
}
