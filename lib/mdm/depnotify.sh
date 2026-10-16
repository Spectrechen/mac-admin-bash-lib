#!/usr/bin/env bash
# shellcheck disable=all
# depnotify.sh - DEPNotify (Installomator label) helpers
#
# Vendor source: Installomator label depnotify from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::mdm::depnotify::suite_installer_url() {
  # TODO: Add actual download URL for DEPNotify
  printf '%s\\n' 'https://example.com/depnotify/installer'
}

maclib::mdm::depnotify::latest_version() {
  # TODO: Add version detection for DEPNotify
  return 1
}

maclib::mdm::depnotify::is_installed() {
  [[ -d "/Applications/Depnotify.app" ]] || [[ -d "$HOME/Applications/Depnotify.app" ]]
}

maclib::mdm::depnotify::installed_path() {
  if [[ -d "/Applications/Depnotify.app" ]]; then
    printf '%s\\n' "/Applications/Depnotify.app"
  elif [[ -d "$HOME/Applications/Depnotify.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Depnotify.app"
  fi
}

maclib::depnotify::install() {
  local url tmp
  url="$(maclib::depnotify::suite_installer_url)"
  tmp="$(mktemp -t "depnotify_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "depnotify::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::mdm::depnotify::update() {
  # No vendor update path documented for "DEPNotify".
  maclib::core::log::error "depnotify::update: no update path"
  return 127
}

maclib::mdm::depnotify::uninstall() {
  # No clean uninstall for "DEPNotify" (documented constraint).
  maclib::core::log::error "depnotify::uninstall: no clean uninstall"
  return 1
}
