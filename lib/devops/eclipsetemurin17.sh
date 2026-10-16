#!/usr/bin/env bash
# shellcheck disable=all
# eclipsetemurin17.sh - Temurin 17 (Installomator label) helpers
#
# Vendor source: Installomator label eclipsetemurin17 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::eclipsetemurin17::suite_installer_url() {
  # TODO: Add actual download URL for Temurin 17
  printf '%s\\n' 'https://example.com/eclipsetemurin17/installer'
}

maclib::devops::eclipsetemurin17::latest_version() {
  # TODO: Add version detection for Temurin 17
  return 1
}

maclib::devops::eclipsetemurin17::is_installed() {
  [[ -d "/Applications/Temurin 17.app" ]] || [[ -d "$HOME/Applications/Temurin 17.app" ]]
}

maclib::devops::eclipsetemurin17::installed_path() {
  if [[ -d "/Applications/Temurin 17.app" ]]; then
    printf '%s\\n' "/Applications/Temurin 17.app"
  elif [[ -d "$HOME/Applications/Temurin 17.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Temurin 17.app"
  fi
}

maclib::eclipsetemurin17::install() {
  local url tmp
  url="$(maclib::eclipsetemurin17::suite_installer_url)"
  tmp="$(mktemp -t "eclipsetemurin17_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eclipsetemurin17::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::eclipsetemurin17::update() {
  # No vendor update path documented for "Temurin 17".
  maclib::core::log::error "eclipsetemurin17::update: no update path"
  return 127
}

maclib::devops::eclipsetemurin17::uninstall() {
  # No clean uninstall for "Temurin 17" (documented constraint).
  maclib::core::log::error "eclipsetemurin17::uninstall: no clean uninstall"
  return 1
}
