#!/usr/bin/env bash
# shellcheck disable=all
# cherryaudiosync.sh - Cherry Audio Sync (Installomator label) helpers
#
# Vendor source: Installomator label cherryaudiosync from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::cherryaudiosync::suite_installer_url() {
  # TODO: Add actual download URL for Cherry Audio Sync
  printf '%s\\n' 'https://example.com/cherryaudiosync/installer'
}

maclib::cloud_storage::cherryaudiosync::latest_version() {
  # TODO: Add version detection for Cherry Audio Sync
  return 1
}

maclib::cloud_storage::cherryaudiosync::is_installed() {
  [[ -d "/Applications/Cherry Audio Sync.app" ]] || [[ -d "$HOME/Applications/Cherry Audio Sync.app" ]]
}

maclib::cloud_storage::cherryaudiosync::installed_path() {
  if [[ -d "/Applications/Cherry Audio Sync.app" ]]; then
    printf '%s\\n' "/Applications/Cherry Audio Sync.app"
  elif [[ -d "$HOME/Applications/Cherry Audio Sync.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cherry Audio Sync.app"
  fi
}

maclib::cherryaudiosync::install() {
  local url tmp
  url="$(maclib::cherryaudiosync::suite_installer_url)"
  tmp="$(mktemp -t "cherryaudiosync_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cherryaudiosync::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::cherryaudiosync::update() {
  # No vendor update path documented for "Cherry Audio Sync".
  maclib::core::log::error "cherryaudiosync::update: no update path"
  return 127
}

maclib::cloud_storage::cherryaudiosync::uninstall() {
  # No clean uninstall for "Cherry Audio Sync" (documented constraint).
  maclib::core::log::error "cherryaudiosync::uninstall: no clean uninstall"
  return 1
}
