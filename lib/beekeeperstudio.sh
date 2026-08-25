#!/usr/bin/env bash
# shellcheck disable=all
# beekeeperstudio.sh - "Beekeeper Studio" (Installomator label) helpers
#
# Vendor source: Installomator label beekeeperstudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "7KK583U8H2".
# Installer type: "dmg".
#

maclib::beekeeperstudio::suite_installer_url() {
  downloadURLFromGit beekeeper-studio beekeeper-studio
}

maclib::beekeeperstudio::latest_version() {
  versionFromGit beekeeper-studio beekeeper-studio
}

maclib::beekeeperstudio::is_installed() {
  [[ -d "/Applications/BeekeeperStudio.app" ]] || [[ -d "$HOME/Applications/BeekeeperStudio.app" ]]
}

maclib::beekeeperstudio::installed_path() {
  if [[ -d "/Applications/BeekeeperStudio.app" ]]; then
    printf "%s\n" "/Applications/BeekeeperStudio.app"
  elif [[ -d "$HOME/Applications/BeekeeperStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/BeekeeperStudio.app"
  fi
}

maclib::beekeeperstudio::install() {
  local url tmp
  url="$(maclib::beekeeperstudio::suite_installer_url)"
  tmp="$(mktemp -d -t "beekeeperstudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "beekeeperstudio::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::beekeeperstudio::update() {
  # No vendor update path documented for "Beekeeper Studio".
  maclib::log::error "beekeeperstudio::update: no update path"
  return 127
}

maclib::beekeeperstudio::uninstall() {
  # No clean uninstall for "Beekeeper Studio" (documented constraint).
  maclib::log::error "beekeeperstudio::uninstall: no clean uninstall"
  return 1
}
