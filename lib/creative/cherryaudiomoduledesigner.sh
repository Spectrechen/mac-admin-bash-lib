#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomoduledesigner.sh - Voltage Module Designer (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomoduledesigner from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiomoduledesigner::suite_installer_url() {
  # TODO: Add actual download URL for Voltage Module Designer
  printf '%s\\n' 'https://example.com/cherryaudiomoduledesigner/installer'
}

maclib::creative::cherryaudiomoduledesigner::latest_version() {
  # TODO: Add version detection for Voltage Module Designer
  return 1
}

maclib::creative::cherryaudiomoduledesigner::is_installed() {
  [[ -d "/Applications/Voltage Module Designer.app" ]] || [[ -d "$HOME/Applications/Voltage Module Designer.app" ]]
}

maclib::creative::cherryaudiomoduledesigner::installed_path() {
  if [[ -d "/Applications/Voltage Module Designer.app" ]]; then
    printf '%s\\n' "/Applications/Voltage Module Designer.app"
  elif [[ -d "$HOME/Applications/Voltage Module Designer.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Voltage Module Designer.app"
  fi
}

maclib::cherryaudiomoduledesigner::install() {
  local url tmp
  url="$(maclib::cherryaudiomoduledesigner::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiomoduledesigner_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomoduledesigner::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiomoduledesigner::update() {
  # No vendor update path documented for "Voltage Module Designer".
  maclib::core::log::error "cherryaudiomoduledesigner::update: no update path"
  return 127
}

maclib::creative::cherryaudiomoduledesigner::uninstall() {
  # No clean uninstall for "Voltage Module Designer" (documented constraint).
  maclib::core::log::error "cherryaudiomoduledesigner::uninstall: no clean uninstall"
  return 1
}
