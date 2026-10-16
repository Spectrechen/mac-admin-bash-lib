#!/usr/bin/env bash
# shellcheck disable=all
# elevate24.sh - Elevate24 (Installomator label) helpers
#
# Vendor source: Installomator label elevate24 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::apps/e::elevate24::suite_installer_url() {
  # TODO: Add actual download URL for Elevate24
  printf '%s\\n' 'https://example.com/elevate24/installer'
}

maclib::apps/e::elevate24::latest_version() {
  # TODO: Add version detection for Elevate24
  return 1
}

maclib::apps/e::elevate24::is_installed() {
  [[ -d "/Applications/Elevate24.app" ]] || [[ -d "$HOME/Applications/Elevate24.app" ]]
}

maclib::apps/e::elevate24::installed_path() {
  if [[ -d "/Applications/Elevate24.app" ]]; then
    printf '%s\\n' "/Applications/Elevate24.app"
  elif [[ -d "$HOME/Applications/Elevate24.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Elevate24.app"
  fi
}

maclib::elevate24::install() {
  local url tmp
  url="$(maclib::elevate24::suite_installer_url)"
  tmp="$(mktemp -t "elevate24_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "elevate24::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::apps/e::elevate24::update() {
  # No vendor update path documented for "Elevate24".
  maclib::core::log::error "elevate24::update: no update path"
  return 127
}

maclib::apps/e::elevate24::uninstall() {
  # No clean uninstall for "Elevate24" (documented constraint).
  maclib::core::log::error "elevate24::uninstall: no clean uninstall"
  return 1
}
