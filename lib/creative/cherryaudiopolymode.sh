#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiopolymode.sh - Polymode Synthesizer (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiopolymode from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiopolymode::suite_installer_url() {
  # TODO: Add actual download URL for Polymode Synthesizer
  printf '%s\\n' 'https://example.com/cherryaudiopolymode/installer'
}

maclib::creative::cherryaudiopolymode::latest_version() {
  # TODO: Add version detection for Polymode Synthesizer
  return 1
}

maclib::creative::cherryaudiopolymode::is_installed() {
  [[ -d "/Applications/Polymode Synthesizer.app" ]] || [[ -d "$HOME/Applications/Polymode Synthesizer.app" ]]
}

maclib::creative::cherryaudiopolymode::installed_path() {
  if [[ -d "/Applications/Polymode Synthesizer.app" ]]; then
    printf '%s\\n' "/Applications/Polymode Synthesizer.app"
  elif [[ -d "$HOME/Applications/Polymode Synthesizer.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Polymode Synthesizer.app"
  fi
}

maclib::cherryaudiopolymode::install() {
  local url tmp
  url="$(maclib::cherryaudiopolymode::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiopolymode_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiopolymode::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiopolymode::update() {
  # No vendor update path documented for "Polymode Synthesizer".
  maclib::core::log::error "cherryaudiopolymode::update: no update path"
  return 127
}

maclib::creative::cherryaudiopolymode::uninstall() {
  # No clean uninstall for "Polymode Synthesizer" (documented constraint).
  maclib::core::log::error "cherryaudiopolymode::uninstall: no clean uninstall"
  return 1
}
