#!/usr/bin/env bash
# shellcheck disable=all
# displaylinkmanager.sh - DisplayLink Manager (Installomator label) helpers
#
# Vendor source: Installomator label displaylinkmanager from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::apps/d::displaylinkmanager::suite_installer_url() {
  # TODO: Add actual download URL for DisplayLink Manager
  printf '%s\\n' 'https://example.com/displaylinkmanager/installer'
}

maclib::apps/d::displaylinkmanager::latest_version() {
  # TODO: Add version detection for DisplayLink Manager
  return 1
}

maclib::apps/d::displaylinkmanager::is_installed() {
  [[ -d "/Applications/Displaylink Manager.app" ]] || [[ -d "$HOME/Applications/Displaylink Manager.app" ]]
}

maclib::apps/d::displaylinkmanager::installed_path() {
  if [[ -d "/Applications/Displaylink Manager.app" ]]; then
    printf '%s\\n' "/Applications/Displaylink Manager.app"
  elif [[ -d "$HOME/Applications/Displaylink Manager.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Displaylink Manager.app"
  fi
}

maclib::displaylinkmanager::install() {
  local url tmp
  url="$(maclib::displaylinkmanager::suite_installer_url)"
  tmp="$(mktemp -t "displaylinkmanager_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "displaylinkmanager::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::apps/d::displaylinkmanager::update() {
  # No vendor update path documented for "DisplayLink Manager".
  maclib::core::log::error "displaylinkmanager::update: no update path"
  return 127
}

maclib::apps/d::displaylinkmanager::uninstall() {
  # No clean uninstall for "DisplayLink Manager" (documented constraint).
  maclib::core::log::error "displaylinkmanager::uninstall: no clean uninstall"
  return 1
}
