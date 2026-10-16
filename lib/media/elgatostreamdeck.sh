#!/usr/bin/env bash
# shellcheck disable=all
# elgatostreamdeck.sh - Elgato Stream Deck (Installomator label) helpers
#
# Vendor source: Installomator label elgatostreamdeck from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::media::elgatostreamdeck::suite_installer_url() {
  # TODO: Add actual download URL for Elgato Stream Deck
  printf '%s\\n' 'https://example.com/elgatostreamdeck/installer'
}

maclib::media::elgatostreamdeck::latest_version() {
  # TODO: Add version detection for Elgato Stream Deck
  return 1
}

maclib::media::elgatostreamdeck::is_installed() {
  [[ -d "/Applications/Elgato Stream Deck.app" ]] || [[ -d "$HOME/Applications/Elgato Stream Deck.app" ]]
}

maclib::media::elgatostreamdeck::installed_path() {
  if [[ -d "/Applications/Elgato Stream Deck.app" ]]; then
    printf '%s\\n' "/Applications/Elgato Stream Deck.app"
  elif [[ -d "$HOME/Applications/Elgato Stream Deck.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Elgato Stream Deck.app"
  fi
}

maclib::elgatostreamdeck::install() {
  local url tmp
  url="$(maclib::elgatostreamdeck::suite_installer_url)"
  tmp="$(mktemp -t "elgatostreamdeck_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "elgatostreamdeck::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::media::elgatostreamdeck::update() {
  # No vendor update path documented for "Elgato Stream Deck".
  maclib::core::log::error "elgatostreamdeck::update: no update path"
  return 127
}

maclib::media::elgatostreamdeck::uninstall() {
  # No clean uninstall for "Elgato Stream Deck" (documented constraint).
  maclib::core::log::error "elgatostreamdeck::uninstall: no clean uninstall"
  return 1
}
