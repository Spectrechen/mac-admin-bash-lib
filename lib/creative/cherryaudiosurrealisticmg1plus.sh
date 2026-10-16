#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosurrealisticmg1plus.sh - Surrealistic MG-1 Plus (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosurrealisticmg1plus from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiosurrealisticmg1plus::suite_installer_url() {
  # TODO: Add actual download URL for Surrealistic MG-1 Plus
  printf '%s\\n' 'https://example.com/cherryaudiosurrealisticmg1plus/installer'
}

maclib::creative::cherryaudiosurrealisticmg1plus::latest_version() {
  # TODO: Add version detection for Surrealistic MG-1 Plus
  return 1
}

maclib::creative::cherryaudiosurrealisticmg1plus::is_installed() {
  [[ -d "/Applications/Surrealistic Mg-1 Plus.app" ]] || [[ -d "$HOME/Applications/Surrealistic Mg-1 Plus.app" ]]
}

maclib::creative::cherryaudiosurrealisticmg1plus::installed_path() {
  if [[ -d "/Applications/Surrealistic Mg-1 Plus.app" ]]; then
    printf '%s\\n' "/Applications/Surrealistic Mg-1 Plus.app"
  elif [[ -d "$HOME/Applications/Surrealistic Mg-1 Plus.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Surrealistic Mg-1 Plus.app"
  fi
}

maclib::cherryaudiosurrealisticmg1plus::install() {
  local url tmp
  url="$(maclib::cherryaudiosurrealisticmg1plus::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiosurrealisticmg1plus_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosurrealisticmg1plus::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiosurrealisticmg1plus::update() {
  # No vendor update path documented for "Surrealistic MG-1 Plus".
  maclib::core::log::error "cherryaudiosurrealisticmg1plus::update: no update path"
  return 127
}

maclib::creative::cherryaudiosurrealisticmg1plus::uninstall() {
  # No clean uninstall for "Surrealistic MG-1 Plus" (documented constraint).
  maclib::core::log::error "cherryaudiosurrealisticmg1plus::uninstall: no clean uninstall"
  return 1
}
