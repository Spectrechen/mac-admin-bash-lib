#!/usr/bin/env bash
# shellcheck disable=all
# diskspace.sh - diskspace (Installomator label) helpers
#
# Vendor source: Installomator label diskspace from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::media::diskspace::suite_installer_url() {
  # TODO: Add actual download URL for diskspace
  printf '%s\\n' 'https://example.com/diskspace/installer'
}

maclib::media::diskspace::latest_version() {
  # TODO: Add version detection for diskspace
  return 1
}

maclib::media::diskspace::is_installed() {
  [[ -d "/Applications/Diskspace.app" ]] || [[ -d "$HOME/Applications/Diskspace.app" ]]
}

maclib::media::diskspace::installed_path() {
  if [[ -d "/Applications/Diskspace.app" ]]; then
    printf '%s\\n' "/Applications/Diskspace.app"
  elif [[ -d "$HOME/Applications/Diskspace.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Diskspace.app"
  fi
}

maclib::diskspace::install() {
  local url tmp
  url="$(maclib::diskspace::suite_installer_url)"
  tmp="$(mktemp -t "diskspace_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "diskspace::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::media::diskspace::update() {
  # No vendor update path documented for "diskspace".
  maclib::core::log::error "diskspace::update: no update path"
  return 127
}

maclib::media::diskspace::uninstall() {
  # No clean uninstall for "diskspace" (documented constraint).
  maclib::core::log::error "diskspace::uninstall: no clean uninstall"
  return 1
}
