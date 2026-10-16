#!/usr/bin/env bash
# shellcheck disable=all
# dragonframe2024.sh - DragonFrame 2024 (Installomator label) helpers
#
# Vendor source: Installomator label dragonframe2024 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::creative::dragonframe2024::suite_installer_url() {
  # TODO: Add actual download URL for DragonFrame 2024
  printf '%s\\n' 'https://example.com/dragonframe2024/installer'
}

maclib::creative::dragonframe2024::latest_version() {
  # TODO: Add version detection for DragonFrame 2024
  return 1
}

maclib::creative::dragonframe2024::is_installed() {
  [[ -d "/Applications/Dragonframe 2024.app" ]] || [[ -d "$HOME/Applications/Dragonframe 2024.app" ]]
}

maclib::creative::dragonframe2024::installed_path() {
  if [[ -d "/Applications/Dragonframe 2024.app" ]]; then
    printf '%s\\n' "/Applications/Dragonframe 2024.app"
  elif [[ -d "$HOME/Applications/Dragonframe 2024.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dragonframe 2024.app"
  fi
}

maclib::dragonframe2024::install() {
  local url tmp
  url="$(maclib::dragonframe2024::suite_installer_url)"
  tmp="$(mktemp -t "dragonframe2024_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "dragonframe2024::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::creative::dragonframe2024::update() {
  # No vendor update path documented for "DragonFrame 2024".
  maclib::core::log::error "dragonframe2024::update: no update path"
  return 127
}

maclib::creative::dragonframe2024::uninstall() {
  # No clean uninstall for "DragonFrame 2024" (documented constraint).
  maclib::core::log::error "dragonframe2024::uninstall: no clean uninstall"
  return 1
}
