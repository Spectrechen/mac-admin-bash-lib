#!/usr/bin/env bash
# shellcheck disable=all
# burpsuiteprofessional.sh - "Burp Suite Professional" (Installomator label) helpers
#
# Vendor source: Installomator label burpsuiteprofessional from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "N82YM748DZ".
# Installer type: macosx".
#

maclib::burpsuiteprofessional::suite_installer_url() {
  https://portswigger.net/burp/releases/startdownload/?product=pro &
  version &
  ="$appNewVersion" &
  type=macosx
}

maclib::burpsuiteprofessional::latest_version() {
  curl -s https://portswigger.net/burp/releases | grep 'releases/professional-community' | head -n 1 | sed 's/.*href="//' | sed 's/".*//' | cut -d '/' -f4 | cut -d '-' -f3-6 | sed -r 's/-/./g'
}

maclib::burpsuiteprofessional::is_installed() {
  [[ -d "/Applications/BurpSuiteProfessional.app" ]] || [[ -d "$HOME/Applications/BurpSuiteProfessional.app" ]]
}

maclib::burpsuiteprofessional::installed_path() {
  if [[ -d "/Applications/BurpSuiteProfessional.app" ]]; then
    printf "%s\n" "/Applications/BurpSuiteProfessional.app"
  elif [[ -d "$HOME/Applications/BurpSuiteProfessional.app" ]]; then
    printf "%s\n" "$HOME/Applications/BurpSuiteProfessional.app"
  fi
}

maclib::burpsuiteprofessional::install() {
  local url tmp
  url="$(maclib::burpsuiteprofessional::suite_installer_url)"
  tmp="$(mktemp -d -t "burpsuiteprofessional.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "burpsuiteprofessional::install: download failed"
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

maclib::burpsuiteprofessional::update() {
  # No vendor update path documented for "Burp Suite Professional".
  maclib::log::error "burpsuiteprofessional::update: no update path"
  return 127
}

maclib::burpsuiteprofessional::uninstall() {
  # No clean uninstall for "Burp Suite Professional" (documented constraint).
  maclib::log::error "burpsuiteprofessional::uninstall: no clean uninstall"
  return 1
}
