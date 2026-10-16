#!/usr/bin/env bash
# shellcheck disable=all
# dymoconnectdesktop.sh - DYMO Connect (Installomator label) helpers
#
# Vendor source: Installomator label dymoconnectdesktop from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::apps/d::dymoconnectdesktop::suite_installer_url() {
  # TODO: Add actual download URL for DYMO Connect
  printf '%s\\n' 'https://example.com/dymoconnectdesktop/installer'
}

maclib::apps/d::dymoconnectdesktop::latest_version() {
  # TODO: Add version detection for DYMO Connect
  return 1
}

maclib::apps/d::dymoconnectdesktop::is_installed() {
  [[ -d "/Applications/Dymo Connect.app" ]] || [[ -d "$HOME/Applications/Dymo Connect.app" ]]
}

maclib::apps/d::dymoconnectdesktop::installed_path() {
  if [[ -d "/Applications/Dymo Connect.app" ]]; then
    printf '%s\\n' "/Applications/Dymo Connect.app"
  elif [[ -d "$HOME/Applications/Dymo Connect.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dymo Connect.app"
  fi
}

maclib::dymoconnectdesktop::install() {
  local url tmp
  url="$(maclib::dymoconnectdesktop::suite_installer_url)"
  tmp="$(mktemp -t "dymoconnectdesktop_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "dymoconnectdesktop::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::apps/d::dymoconnectdesktop::update() {
  # No vendor update path documented for "DYMO Connect".
  maclib::core::log::error "dymoconnectdesktop::update: no update path"
  return 127
}

maclib::apps/d::dymoconnectdesktop::uninstall() {
  # No clean uninstall for "DYMO Connect" (documented constraint).
  maclib::core::log::error "dymoconnectdesktop::uninstall: no clean uninstall"
  return 1
}
