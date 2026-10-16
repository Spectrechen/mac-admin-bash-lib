#!/usr/bin/env bash
# shellcheck disable=all
# busycontacts.sh - "BusyContacts" (Installomator label) helpers
#
# Vendor source: Installomator label busycontacts from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "N4RA379GBW".
# Installer type: "dmg".
#

maclib::apps::b::busycontacts::suite_installer_url() {
  https://www.busymac.com/download/BusyContacts.dmg
}

maclib::apps::b::busycontacts::latest_version() {
  curl -ILs "https://www.busymac.com/download/BusyContacts.dmg" | grep -m 1 -i '^location' | sed 's/.*bct-//' | sed 's/.dmg//'
}

maclib::apps::b::busycontacts::is_installed() {
  [[ -d "/Applications/BusyContacts.app" ]] || [[ -d "$HOME/Applications/BusyContacts.app" ]]
}

maclib::apps::b::busycontacts::installed_path() {
  if [[ -d "/Applications/BusyContacts.app" ]]; then
    printf "%s\n" "/Applications/BusyContacts.app"
  elif [[ -d "$HOME/Applications/BusyContacts.app" ]]; then
    printf "%s\n" "$HOME/Applications/BusyContacts.app"
  fi
}

maclib::apps::b::busycontacts::install() {
  local url tmp
  url="$(maclib::apps::b::busycontacts::suite_installer_url)"
  tmp="$(mktemp -d -t "busycontacts.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "busycontacts::install: download failed"
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

maclib::apps::b::busycontacts::update() {
  # No vendor update path documented for "BusyContacts".
  maclib::core::log::error "busycontacts::update: no update path"
  return 127
}

maclib::apps::b::busycontacts::uninstall() {
  # No clean uninstall for "BusyContacts" (documented constraint).
  maclib::core::log::error "busycontacts::uninstall: no clean uninstall"
  return 1
}
