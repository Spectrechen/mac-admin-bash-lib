#!/usr/bin/env bash
# shellcheck disable=all
# eclipsetemurin8.sh - Temurin 8 (Installomator label) helpers
#
# Vendor source: Installomator label eclipsetemurin8 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::devops::eclipsetemurin8::suite_installer_url() {
  # TODO: Add actual download URL for Temurin 8
  printf '%s\\n' 'https://example.com/eclipsetemurin8/installer'
}

maclib::devops::eclipsetemurin8::latest_version() {
  # TODO: Add version detection for Temurin 8
  return 1
}

maclib::devops::eclipsetemurin8::is_installed() {
  [[ -d "/Applications/Temurin 8.app" ]] || [[ -d "$HOME/Applications/Temurin 8.app" ]]
}

maclib::devops::eclipsetemurin8::installed_path() {
  if [[ -d "/Applications/Temurin 8.app" ]]; then
    printf '%s\\n' "/Applications/Temurin 8.app"
  elif [[ -d "$HOME/Applications/Temurin 8.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Temurin 8.app"
  fi
}

maclib::eclipsetemurin8::install() {
  local url tmp
  url="$(maclib::eclipsetemurin8::suite_installer_url)"
  tmp="$(mktemp -t "eclipsetemurin8_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "eclipsetemurin8::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::devops::eclipsetemurin8::update() {
  # No vendor update path documented for "Temurin 8".
  maclib::core::log::error "eclipsetemurin8::update: no update path"
  return 127
}

maclib::devops::eclipsetemurin8::uninstall() {
  # No clean uninstall for "Temurin 8" (documented constraint).
  maclib::core::log::error "eclipsetemurin8::uninstall: no clean uninstall"
  return 1
}
