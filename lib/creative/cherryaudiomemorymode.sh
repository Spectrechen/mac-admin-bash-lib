#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiomemorymode.sh - Memorymode (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiomemorymode from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::cherryaudiomemorymode::suite_installer_url() {
  # TODO: Add actual download URL for Memorymode
  printf '%s\\n' 'https://example.com/cherryaudiomemorymode/installer'
}

maclib::creative::cherryaudiomemorymode::latest_version() {
  # TODO: Add version detection for Memorymode
  return 1
}

maclib::creative::cherryaudiomemorymode::is_installed() {
  [[ -d "/Applications/Memorymode.app" ]] || [[ -d "$HOME/Applications/Memorymode.app" ]]
}

maclib::creative::cherryaudiomemorymode::installed_path() {
  if [[ -d "/Applications/Memorymode.app" ]]; then
    printf '%s\\n' "/Applications/Memorymode.app"
  elif [[ -d "$HOME/Applications/Memorymode.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Memorymode.app"
  fi
}

maclib::cherryaudiomemorymode::install() {
  local url tmp
  url="$(maclib::cherryaudiomemorymode::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiomemorymode_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiomemorymode::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::cherryaudiomemorymode::update() {
  # No vendor update path documented for "Memorymode".
  maclib::core::log::error "cherryaudiomemorymode::update: no update path"
  return 127
}

maclib::creative::cherryaudiomemorymode::uninstall() {
  # No clean uninstall for "Memorymode" (documented constraint).
  maclib::core::log::error "cherryaudiomemorymode::uninstall: no clean uninstall"
  return 1
}
