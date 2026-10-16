#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiovoltagemodular.sh - Voltage Modular (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiovoltagemodular from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiovoltagemodular::suite_installer_url() {
  # TODO: Add actual download URL for Voltage Modular
  printf '%s\\n' 'https://example.com/cherryaudiovoltagemodular/installer'
}

maclib::creative::cherryaudiovoltagemodular::latest_version() {
  # TODO: Add version detection for Voltage Modular
  return 1
}

maclib::creative::cherryaudiovoltagemodular::is_installed() {
  [[ -d "/Applications/Voltage Modular.app" ]] || [[ -d "$HOME/Applications/Voltage Modular.app" ]]
}

maclib::creative::cherryaudiovoltagemodular::installed_path() {
  if [[ -d "/Applications/Voltage Modular.app" ]]; then
    printf '%s\\n' "/Applications/Voltage Modular.app"
  elif [[ -d "$HOME/Applications/Voltage Modular.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Voltage Modular.app"
  fi
}

maclib::cherryaudiovoltagemodular::install() {
  local url tmp
  url="$(maclib::cherryaudiovoltagemodular::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiovoltagemodular_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiovoltagemodular::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiovoltagemodular::update() {
  # No vendor update path documented for "Voltage Modular".
  maclib::core::log::error "cherryaudiovoltagemodular::update: no update path"
  return 127
}

maclib::creative::cherryaudiovoltagemodular::uninstall() {
  # No clean uninstall for "Voltage Modular" (documented constraint).
  maclib::core::log::error "cherryaudiovoltagemodular::uninstall: no clean uninstall"
  return 1
}
