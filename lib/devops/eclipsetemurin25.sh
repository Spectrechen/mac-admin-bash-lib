#!/usr/bin/env bash
# shellcheck disable=all
# eclipsetemurin25.sh - Temurin 25 (Installomator label) helpers
#
# Vendor source: Installomator label eclipsetemurin25 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::eclipsetemurin25::suite_installer_url() {
  # TODO: Add actual download URL for Temurin 25
  printf '%s\\n' 'https://example.com/eclipsetemurin25/installer'
}

maclib::devops::eclipsetemurin25::latest_version() {
  # TODO: Add version detection for Temurin 25
  return 1
}

maclib::devops::eclipsetemurin25::is_installed() {
  [[ -d "/Applications/Temurin 25.app" ]] || [[ -d "$HOME/Applications/Temurin 25.app" ]]
}

maclib::devops::eclipsetemurin25::installed_path() {
  if [[ -d "/Applications/Temurin 25.app" ]]; then
    printf '%s\\n' "/Applications/Temurin 25.app"
  elif [[ -d "$HOME/Applications/Temurin 25.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Temurin 25.app"
  fi
}

maclib::eclipsetemurin25::install() {
  local url tmp
  url="$(maclib::eclipsetemurin25::suite_installer_url)"
  tmp="$(mktemp -t "eclipsetemurin25_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eclipsetemurin25::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::eclipsetemurin25::update() {
  # No vendor update path documented for "Temurin 25".
  maclib::core::log::error "eclipsetemurin25::update: no update path"
  return 127
}

maclib::devops::eclipsetemurin25::uninstall() {
  # No clean uninstall for "Temurin 25" (documented constraint).
  maclib::core::log::error "eclipsetemurin25::uninstall: no clean uninstall"
  return 1
}
