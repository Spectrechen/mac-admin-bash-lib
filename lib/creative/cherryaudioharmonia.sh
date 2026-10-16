#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudioharmonia.sh - Harmonia (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudioharmonia from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudioharmonia::suite_installer_url() {
  # TODO: Add actual download URL for Harmonia
  printf '%s\\n' 'https://example.com/cherryaudioharmonia/installer'
}

maclib::creative::cherryaudioharmonia::latest_version() {
  # TODO: Add version detection for Harmonia
  return 1
}

maclib::creative::cherryaudioharmonia::is_installed() {
  [[ -d "/Applications/Harmonia.app" ]] || [[ -d "$HOME/Applications/Harmonia.app" ]]
}

maclib::creative::cherryaudioharmonia::installed_path() {
  if [[ -d "/Applications/Harmonia.app" ]]; then
    printf '%s\\n' "/Applications/Harmonia.app"
  elif [[ -d "$HOME/Applications/Harmonia.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Harmonia.app"
  fi
}

maclib::cherryaudioharmonia::install() {
  local url tmp
  url="$(maclib::cherryaudioharmonia::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudioharmonia_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudioharmonia::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudioharmonia::update() {
  # No vendor update path documented for "Harmonia".
  maclib::core::log::error "cherryaudioharmonia::update: no update path"
  return 127
}

maclib::creative::cherryaudioharmonia::uninstall() {
  # No clean uninstall for "Harmonia" (documented constraint).
  maclib::core::log::error "cherryaudioharmonia::uninstall: no clean uninstall"
  return 1
}
