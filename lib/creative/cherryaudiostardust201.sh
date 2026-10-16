#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiostardust201.sh - Stardust 201 Tape Echo (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiostardust201 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiostardust201::suite_installer_url() {
  # TODO: Add actual download URL for Stardust 201 Tape Echo
  printf '%s\\n' 'https://example.com/cherryaudiostardust201/installer'
}

maclib::creative::cherryaudiostardust201::latest_version() {
  # TODO: Add version detection for Stardust 201 Tape Echo
  return 1
}

maclib::creative::cherryaudiostardust201::is_installed() {
  [[ -d "/Applications/Stardust 201 Tape Echo.app" ]] || [[ -d "$HOME/Applications/Stardust 201 Tape Echo.app" ]]
}

maclib::creative::cherryaudiostardust201::installed_path() {
  if [[ -d "/Applications/Stardust 201 Tape Echo.app" ]]; then
    printf '%s\\n' "/Applications/Stardust 201 Tape Echo.app"
  elif [[ -d "$HOME/Applications/Stardust 201 Tape Echo.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Stardust 201 Tape Echo.app"
  fi
}

maclib::cherryaudiostardust201::install() {
  local url tmp
  url="$(maclib::cherryaudiostardust201::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiostardust201_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiostardust201::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiostardust201::update() {
  # No vendor update path documented for "Stardust 201 Tape Echo".
  maclib::core::log::error "cherryaudiostardust201::update: no update path"
  return 127
}

maclib::creative::cherryaudiostardust201::uninstall() {
  # No clean uninstall for "Stardust 201 Tape Echo" (documented constraint).
  maclib::core::log::error "cherryaudiostardust201::uninstall: no clean uninstall"
  return 1
}
