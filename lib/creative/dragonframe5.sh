#!/usr/bin/env bash
# shellcheck disable=all
# dragonframe5.sh - DragonFrame 5 (Installomator label) helpers
#
# Vendor source: Installomator label dragonframe5 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::dragonframe5::suite_installer_url() {
  # TODO: Add actual download URL for DragonFrame 5
  printf '%s\\n' 'https://example.com/dragonframe5/installer'
}

maclib::creative::dragonframe5::latest_version() {
  # TODO: Add version detection for DragonFrame 5
  return 1
}

maclib::creative::dragonframe5::is_installed() {
  [[ -d "/Applications/Dragonframe 5.app" ]] || [[ -d "$HOME/Applications/Dragonframe 5.app" ]]
}

maclib::creative::dragonframe5::installed_path() {
  if [[ -d "/Applications/Dragonframe 5.app" ]]; then
    printf '%s\\n' "/Applications/Dragonframe 5.app"
  elif [[ -d "$HOME/Applications/Dragonframe 5.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dragonframe 5.app"
  fi
}

maclib::dragonframe5::install() {
  local url tmp
  url="$(maclib::dragonframe5::suite_installer_url)"
  tmp="$(mktemp -t "dragonframe5_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "dragonframe5::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::dragonframe5::update() {
  # No vendor update path documented for "DragonFrame 5".
  maclib::core::log::error "dragonframe5::update: no update path"
  return 127
}

maclib::creative::dragonframe5::uninstall() {
  # No clean uninstall for "DragonFrame 5" (documented constraint).
  maclib::core::log::error "dragonframe5::uninstall: no clean uninstall"
  return 1
}
