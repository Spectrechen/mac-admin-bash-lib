#!/usr/bin/env bash
# shellcheck disable=all
# catoclient.sh - "CatoClient" (Installomator label) helpers
#
# Vendor source: Installomator label catoclient from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "CKGSB8CH43".
# Installer type: "pkg".
#

maclib::catoclient::suite_installer_url() {
  https://clientdownload.catonetworks.com/public/clients/CatoClient.pkg
}

maclib::catoclient::latest_version() {
  local downloadURL
  downloadURL="$(https://clientdownload.catonetworks.com/public/clients/CatoClient.pkg)"
  curl -Ls -o /dev/null -w %{url_effective} "${downloadURL}" | sed -E 's/.*\/([0-9.]*)\/.*/\1/g' | awk -F '.' '{print $1 "." $2 "." $3}'
}

maclib::catoclient::is_installed() {
  [[ -d "/Applications/CatoClient.app" ]] || [[ -d "$HOME/Applications/CatoClient.app" ]]
}

maclib::catoclient::installed_path() {
  if [[ -d "/Applications/CatoClient.app" ]]; then
    printf "%s\n" "/Applications/CatoClient.app"
  elif [[ -d "$HOME/Applications/CatoClient.app" ]]; then
    printf "%s\n" "$HOME/Applications/CatoClient.app"
  fi
}

maclib::catoclient::install() {
  local url tmp
  url="$(maclib::catoclient::suite_installer_url)"
  tmp="$(mktemp -d -t "catoclient.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "catoclient::install: download failed"
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

maclib::catoclient::update() {
  # No vendor update path documented for "CatoClient".
  maclib::log::error "catoclient::update: no update path"
  return 127
}

maclib::catoclient::uninstall() {
  # No clean uninstall for "CatoClient" (documented constraint).
  maclib::log::error "catoclient::uninstall: no clean uninstall"
  return 1
}
