#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudionovachord.sh - Novachord (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudionovachord from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudionovachord::suite_installer_url() {
  # TODO: Add actual download URL for Novachord
  printf '%s\\n' 'https://example.com/cherryaudionovachord/installer'
}

maclib::creative::cherryaudionovachord::latest_version() {
  # TODO: Add version detection for Novachord
  return 1
}

maclib::creative::cherryaudionovachord::is_installed() {
  [[ -d "/Applications/Novachord.app" ]] || [[ -d "$HOME/Applications/Novachord.app" ]]
}

maclib::creative::cherryaudionovachord::installed_path() {
  if [[ -d "/Applications/Novachord.app" ]]; then
    printf '%s\\n' "/Applications/Novachord.app"
  elif [[ -d "$HOME/Applications/Novachord.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Novachord.app"
  fi
}

maclib::cherryaudionovachord::install() {
  local url tmp
  url="$(maclib::cherryaudionovachord::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudionovachord_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudionovachord::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudionovachord::update() {
  # No vendor update path documented for "Novachord".
  maclib::core::log::error "cherryaudionovachord::update: no update path"
  return 127
}

maclib::creative::cherryaudionovachord::uninstall() {
  # No clean uninstall for "Novachord" (documented constraint).
  maclib::core::log::error "cherryaudionovachord::uninstall: no clean uninstall"
  return 1
}
