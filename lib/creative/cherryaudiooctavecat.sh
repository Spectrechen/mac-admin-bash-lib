#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiooctavecat.sh - Octave Cat (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiooctavecat from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiooctavecat::suite_installer_url() {
  # TODO: Add actual download URL for Octave Cat
  printf '%s\\n' 'https://example.com/cherryaudiooctavecat/installer'
}

maclib::creative::cherryaudiooctavecat::latest_version() {
  # TODO: Add version detection for Octave Cat
  return 1
}

maclib::creative::cherryaudiooctavecat::is_installed() {
  [[ -d "/Applications/Octave Cat.app" ]] || [[ -d "$HOME/Applications/Octave Cat.app" ]]
}

maclib::creative::cherryaudiooctavecat::installed_path() {
  if [[ -d "/Applications/Octave Cat.app" ]]; then
    printf '%s\\n' "/Applications/Octave Cat.app"
  elif [[ -d "$HOME/Applications/Octave Cat.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Octave Cat.app"
  fi
}

maclib::cherryaudiooctavecat::install() {
  local url tmp
  url="$(maclib::cherryaudiooctavecat::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiooctavecat_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiooctavecat::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiooctavecat::update() {
  # No vendor update path documented for "Octave Cat".
  maclib::core::log::error "cherryaudiooctavecat::update: no update path"
  return 127
}

maclib::creative::cherryaudiooctavecat::uninstall() {
  # No clean uninstall for "Octave Cat" (documented constraint).
  maclib::core::log::error "cherryaudiooctavecat::uninstall: no clean uninstall"
  return 1
}
