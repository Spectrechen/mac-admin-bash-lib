#!/usr/bin/env bash
# shellcheck disable=all
# bibdesk.sh - "BibDesk" (Installomator label) helpers
#
# Vendor source: Installomator label bibdesk from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "J33JTA7SY9".
# Installer type: "dmg".
#

maclib::bibdesk::suite_installer_url() {
  echo $html_page_source | grep -i "current version" | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}'
}

maclib::bibdesk::latest_version() {
  echo $html_page_source | grep -i "current version" | sed -n 's:.*BibDesk-\(.*\).dmg.*:\1:p'
}

maclib::bibdesk::is_installed() {
  [[ -d "/Applications/BibDesk.app" ]] || [[ -d "$HOME/Applications/BibDesk.app" ]]
}

maclib::bibdesk::installed_path() {
  if [[ -d "/Applications/BibDesk.app" ]]; then
    printf "%s\n" "/Applications/BibDesk.app"
  elif [[ -d "$HOME/Applications/BibDesk.app" ]]; then
    printf "%s\n" "$HOME/Applications/BibDesk.app"
  fi
}

maclib::bibdesk::install() {
  local url tmp
  url="$(maclib::bibdesk::suite_installer_url)"
  tmp="$(mktemp -d -t "bibdesk.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bibdesk::install: download failed"
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

maclib::bibdesk::update() {
  # No vendor update path documented for "BibDesk".
  maclib::log::error "bibdesk::update: no update path"
  return 127
}

maclib::bibdesk::uninstall() {
  # No clean uninstall for "BibDesk" (documented constraint).
  maclib::log::error "bibdesk::uninstall: no clean uninstall"
  return 1
}
