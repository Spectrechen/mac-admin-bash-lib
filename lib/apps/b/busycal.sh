#!/usr/bin/env bash
# shellcheck disable=all
# busycal.sh - "BusyCal" (Installomator label) helpers
#
# Vendor source: Installomator label busycal from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "N4RA379GBW".
# Installer type: "dmg".
#

maclib::apps::b::busycal::suite_installer_url() {
  https://www.busymac.com/download/BusyCal.dmg
}

maclib::apps::b::busycal::latest_version() {
  curl -ILs "https://www.busymac.com/download/BusyCal.dmg" | grep -m 1 -i '^location' | sed 's/.*bcl-//' | sed 's/.dmg//'
}

maclib::apps::b::busycal::is_installed() {
  [[ -d "/Applications/BusyCal.app" ]] || [[ -d "$HOME/Applications/BusyCal.app" ]]
}

maclib::apps::b::busycal::installed_path() {
  if [[ -d "/Applications/BusyCal.app" ]]; then
    printf "%s\n" "/Applications/BusyCal.app"
  elif [[ -d "$HOME/Applications/BusyCal.app" ]]; then
    printf "%s\n" "$HOME/Applications/BusyCal.app"
  fi
}

maclib::apps::b::busycal::install() {
  local url tmp
  url="$(maclib::apps::b::busycal::suite_installer_url)"
  tmp="$(mktemp -d -t "busycal.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "busycal::install: download failed"
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

maclib::apps::b::busycal::update() {
  # No vendor update path documented for "BusyCal".
  maclib::core::log::error "busycal::update: no update path"
  return 127
}

maclib::apps::b::busycal::uninstall() {
  # No clean uninstall for "BusyCal" (documented constraint).
  maclib::core::log::error "busycal::uninstall: no clean uninstall"
  return 1
}
