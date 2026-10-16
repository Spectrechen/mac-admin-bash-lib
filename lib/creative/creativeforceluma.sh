#!/usr/bin/env bash
# shellcheck disable=all
# creativeforceluma.sh - Luma (Installomator label) helpers
#
# Vendor source: Installomator label creativeforceluma from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::creativeforceluma::suite_installer_url() {
  # TODO: Add actual download URL for Luma
  printf '%s\\n' 'https://example.com/creativeforceluma/installer'
}

maclib::creative::creativeforceluma::latest_version() {
  # TODO: Add version detection for Luma
  return 1
}

maclib::creative::creativeforceluma::is_installed() {
  [[ -d "/Applications/Luma.app" ]] || [[ -d "$HOME/Applications/Luma.app" ]]
}

maclib::creative::creativeforceluma::installed_path() {
  if [[ -d "/Applications/Luma.app" ]]; then
    printf '%s\\n' "/Applications/Luma.app"
  elif [[ -d "$HOME/Applications/Luma.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Luma.app"
  fi
}

maclib::creativeforceluma::install() {
  local url tmp
  url="$(maclib::creativeforceluma::suite_installer_url)"
  tmp="$(mktemp -t "creativeforceluma_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "creativeforceluma::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::creativeforceluma::update() {
  # No vendor update path documented for "Luma".
  maclib::core::log::error "creativeforceluma::update: no update path"
  return 127
}

maclib::creative::creativeforceluma::uninstall() {
  # No clean uninstall for "Luma" (documented constraint).
  maclib::core::log::error "creativeforceluma::uninstall: no clean uninstall"
  return 1
}
