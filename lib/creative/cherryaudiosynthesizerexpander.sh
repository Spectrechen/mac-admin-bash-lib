#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosynthesizerexpander.sh - Synthesizer Expander Module (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosynthesizerexpander from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiosynthesizerexpander::suite_installer_url() {
  # TODO: Add actual download URL for Synthesizer Expander Module
  printf '%s\\n' 'https://example.com/cherryaudiosynthesizerexpander/installer'
}

maclib::creative::cherryaudiosynthesizerexpander::latest_version() {
  # TODO: Add version detection for Synthesizer Expander Module
  return 1
}

maclib::creative::cherryaudiosynthesizerexpander::is_installed() {
  [[ -d "/Applications/Synthesizer Expander Module.app" ]] || [[ -d "$HOME/Applications/Synthesizer Expander Module.app" ]]
}

maclib::creative::cherryaudiosynthesizerexpander::installed_path() {
  if [[ -d "/Applications/Synthesizer Expander Module.app" ]]; then
    printf '%s\\n' "/Applications/Synthesizer Expander Module.app"
  elif [[ -d "$HOME/Applications/Synthesizer Expander Module.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Synthesizer Expander Module.app"
  fi
}

maclib::cherryaudiosynthesizerexpander::install() {
  local url tmp
  url="$(maclib::cherryaudiosynthesizerexpander::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiosynthesizerexpander_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosynthesizerexpander::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiosynthesizerexpander::update() {
  # No vendor update path documented for "Synthesizer Expander Module".
  maclib::core::log::error "cherryaudiosynthesizerexpander::update: no update path"
  return 127
}

maclib::creative::cherryaudiosynthesizerexpander::uninstall() {
  # No clean uninstall for "Synthesizer Expander Module" (documented constraint).
  maclib::core::log::error "cherryaudiosynthesizerexpander::uninstall: no clean uninstall"
  return 1
}
