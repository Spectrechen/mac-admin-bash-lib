#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomercury4.sh - Mercury-4 (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomercury4 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiomercury4::suite_installer_url() {
  # TODO: Add actual download URL for Mercury-4
  printf '%s\\n' 'https://example.com/cherryaudiomercury4/installer'
}

maclib::creative::cherryaudiomercury4::latest_version() {
  # TODO: Add version detection for Mercury-4
  return 1
}

maclib::creative::cherryaudiomercury4::is_installed() {
  [[ -d "/Applications/Mercury-4.app" ]] || [[ -d "$HOME/Applications/Mercury-4.app" ]]
}

maclib::creative::cherryaudiomercury4::installed_path() {
  if [[ -d "/Applications/Mercury-4.app" ]]; then
    printf '%s\\n' "/Applications/Mercury-4.app"
  elif [[ -d "$HOME/Applications/Mercury-4.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Mercury-4.app"
  fi
}

maclib::cherryaudiomercury4::install() {
  local url tmp
  url="$(maclib::cherryaudiomercury4::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiomercury4_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomercury4::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiomercury4::update() {
  # No vendor update path documented for "Mercury-4".
  maclib::core::log::error "cherryaudiomercury4::update: no update path"
  return 127
}

maclib::creative::cherryaudiomercury4::uninstall() {
  # No clean uninstall for "Mercury-4" (documented constraint).
  maclib::core::log::error "cherryaudiomercury4::uninstall: no clean uninstall"
  return 1
}
