#!/usr/bin/env bash
# shellcheck disable=all
# creativeforcetriad.sh - Triad (Installomator label) helpers
#
# Vendor source: Installomator label creativeforcetriad from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::creativeforcetriad::suite_installer_url() {
  # TODO: Add actual download URL for Triad
  printf '%s\\n' 'https://example.com/creativeforcetriad/installer'
}

maclib::creative::creativeforcetriad::latest_version() {
  # TODO: Add version detection for Triad
  return 1
}

maclib::creative::creativeforcetriad::is_installed() {
  [[ -d "/Applications/Triad.app" ]] || [[ -d "$HOME/Applications/Triad.app" ]]
}

maclib::creative::creativeforcetriad::installed_path() {
  if [[ -d "/Applications/Triad.app" ]]; then
    printf '%s\\n' "/Applications/Triad.app"
  elif [[ -d "$HOME/Applications/Triad.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Triad.app"
  fi
}

maclib::creativeforcetriad::install() {
  local url tmp
  url="$(maclib::creativeforcetriad::suite_installer_url)"
  tmp="$(mktemp -t "creativeforcetriad_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "creativeforcetriad::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::creativeforcetriad::update() {
  # No vendor update path documented for "Triad".
  maclib::core::log::error "creativeforcetriad::update: no update path"
  return 127
}

maclib::creative::creativeforcetriad::uninstall() {
  # No clean uninstall for "Triad" (documented constraint).
  maclib::core::log::error "creativeforcetriad::uninstall: no clean uninstall"
  return 1
}
