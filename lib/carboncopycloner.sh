#!/usr/bin/env bash
# shellcheck disable=all
# carboncopycloner.sh - "Carbon Copy Cloner" (Installomator label) helpers
#
# Vendor source: Installomator label carboncopycloner from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "L4F2DED5Q7".
# Installer type: "zip".
#

maclib::carboncopycloner::suite_installer_url() {
  curl -fsIL "https://api.bombich.com/download/ccc?v=latest" | grep -i ^location | sed -E 's/.*(https.*\.zip).*/\1/g'
}

maclib::carboncopycloner::latest_version() {
  sed -E 's/.*-([0-9.]*)\.zip/\1/g' <<<$downloadURL | sed 's/\.[^.]*$//'
}

maclib::carboncopycloner::is_installed() {
  [[ -d "/Applications/CarbonCopyCloner.app" ]] || [[ -d "$HOME/Applications/CarbonCopyCloner.app" ]]
}

maclib::carboncopycloner::installed_path() {
  if [[ -d "/Applications/CarbonCopyCloner.app" ]]; then
    printf "%s\n" "/Applications/CarbonCopyCloner.app"
  elif [[ -d "$HOME/Applications/CarbonCopyCloner.app" ]]; then
    printf "%s\n" "$HOME/Applications/CarbonCopyCloner.app"
  fi
}

maclib::carboncopycloner::install() {
  local url tmp
  url="$(maclib::carboncopycloner::suite_installer_url)"
  tmp="$(mktemp -d -t "carboncopycloner.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "carboncopycloner::install: download failed"
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

maclib::carboncopycloner::update() {
  # No vendor update path documented for "Carbon Copy Cloner".
  maclib::log::error "carboncopycloner::update: no update path"
  return 127
}

maclib::carboncopycloner::uninstall() {
  # No clean uninstall for "Carbon Copy Cloner" (documented constraint).
  maclib::log::error "carboncopycloner::uninstall: no clean uninstall"
  return 1
}
