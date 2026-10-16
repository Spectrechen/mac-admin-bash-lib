#!/usr/bin/env bash
# shellcheck disable=all
# elgatocamerahub.sh - Elgato Camera Hub (Installomator label) helpers
#
# Vendor source: Installomator label elgatocamerahub from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::media::elgatocamerahub::suite_installer_url() {
  # TODO: Add actual download URL for Elgato Camera Hub
  printf '%s\\n' 'https://example.com/elgatocamerahub/installer'
}

maclib::media::elgatocamerahub::latest_version() {
  # TODO: Add version detection for Elgato Camera Hub
  return 1
}

maclib::media::elgatocamerahub::is_installed() {
  [[ -d "/Applications/Elgato Camera Hub.app" ]] || [[ -d "$HOME/Applications/Elgato Camera Hub.app" ]]
}

maclib::media::elgatocamerahub::installed_path() {
  if [[ -d "/Applications/Elgato Camera Hub.app" ]]; then
    printf '%s\\n' "/Applications/Elgato Camera Hub.app"
  elif [[ -d "$HOME/Applications/Elgato Camera Hub.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Elgato Camera Hub.app"
  fi
}

maclib::elgatocamerahub::install() {
  local url tmp
  url="$(maclib::elgatocamerahub::suite_installer_url)"
  tmp="$(mktemp -t "elgatocamerahub_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "elgatocamerahub::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::media::elgatocamerahub::update() {
  # No vendor update path documented for "Elgato Camera Hub".
  maclib::core::log::error "elgatocamerahub::update: no update path"
  return 127
}

maclib::media::elgatocamerahub::uninstall() {
  # No clean uninstall for "Elgato Camera Hub" (documented constraint).
  maclib::core::log::error "elgatocamerahub::uninstall: no clean uninstall"
  return 1
}
