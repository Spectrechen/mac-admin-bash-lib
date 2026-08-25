#!/usr/bin/env bash
# shellcheck disable=all
# cameracontroller.sh - "CameraController" (Installomator label) helpers
#
# Vendor source: Installomator label cameracontroller from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "PY9WJ3M9MW".
# Installer type: "zip".
#

maclib::cameracontroller::suite_installer_url() {
  downloadURLFromGit Itaybre CameraController
}

maclib::cameracontroller::latest_version() {
  versionFromGit Itaybre CameraController
}

maclib::cameracontroller::is_installed() {
  [[ -d "/Applications/CameraController.app" ]] || [[ -d "$HOME/Applications/CameraController.app" ]]
}

maclib::cameracontroller::installed_path() {
  if [[ -d "/Applications/CameraController.app" ]]; then
    printf "%s\n" "/Applications/CameraController.app"
  elif [[ -d "$HOME/Applications/CameraController.app" ]]; then
    printf "%s\n" "$HOME/Applications/CameraController.app"
  fi
}

maclib::cameracontroller::install() {
  local url tmp
  url="$(maclib::cameracontroller::suite_installer_url)"
  tmp="$(mktemp -d -t "cameracontroller.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "cameracontroller::install: download failed"
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

maclib::cameracontroller::update() {
  # No vendor update path documented for "CameraController".
  maclib::log::error "cameracontroller::update: no update path"
  return 127
}

maclib::cameracontroller::uninstall() {
  # No clean uninstall for "CameraController" (documented constraint).
  maclib::log::error "cameracontroller::uninstall: no clean uninstall"
  return 1
}
