#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomercury6.sh - Mercury-6 (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomercury6 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiomercury6::suite_installer_url() {
  # TODO: Add actual download URL for Mercury-6
  printf '%s\\n' 'https://example.com/cherryaudiomercury6/installer'
}

maclib::creative::cherryaudiomercury6::latest_version() {
  # TODO: Add version detection for Mercury-6
  return 1
}

maclib::creative::cherryaudiomercury6::is_installed() {
  [[ -d "/Applications/Mercury-6.app" ]] || [[ -d "$HOME/Applications/Mercury-6.app" ]]
}

maclib::creative::cherryaudiomercury6::installed_path() {
  if [[ -d "/Applications/Mercury-6.app" ]]; then
    printf '%s\\n' "/Applications/Mercury-6.app"
  elif [[ -d "$HOME/Applications/Mercury-6.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Mercury-6.app"
  fi
}

maclib::cherryaudiomercury6::install() {
  local url tmp
  url="$(maclib::cherryaudiomercury6::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiomercury6_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomercury6::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiomercury6::update() {
  # No vendor update path documented for "Mercury-6".
  maclib::core::log::error "cherryaudiomercury6::update: no update path"
  return 127
}

maclib::creative::cherryaudiomercury6::uninstall() {
  # No clean uninstall for "Mercury-6" (documented constraint).
  maclib::core::log::error "cherryaudiomercury6::uninstall: no clean uninstall"
  return 1
}
