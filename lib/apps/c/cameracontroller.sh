#!/usr/bin/env bash
# shellcheck disable=all
# cameracontroller.sh - "CameraController" (Installomator label) helpers
#
# Vendor source: Installomator label cameracontroller from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "PY9WJ3M9MW".
# Installer type: "zip".
#

maclib::apps::c::cameracontroller::suite_installer_url() {
  downloadURLFromGit Itaybre CameraController
}

maclib::apps::c::cameracontroller::latest_version() {
  versionFromGit Itaybre CameraController
}

maclib::apps::c::cameracontroller::is_installed() {
  [[ -d "/Applications/CameraController.app" ]] || [[ -d "$HOME/Applications/CameraController.app" ]]
}

maclib::apps::c::cameracontroller::installed_path() {
  if [[ -d "/Applications/CameraController.app" ]]; then
    printf "%s\n" "/Applications/CameraController.app"
  elif [[ -d "$HOME/Applications/CameraController.app" ]]; then
    printf "%s\n" "$HOME/Applications/CameraController.app"
  fi
}

maclib::apps::c::cameracontroller::install() {
  local url tmp
  url="$(maclib::apps::c::cameracontroller::suite_installer_url)"
  tmp="$(mktemp -d -t "cameracontroller.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cameracontroller::install: download failed"
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

maclib::apps::c::cameracontroller::update() {
  # No vendor update path documented for "CameraController".
  maclib::core::log::error "cameracontroller::update: no update path"
  return 127
}

maclib::apps::c::cameracontroller::uninstall() {
  # No clean uninstall for "CameraController" (documented constraint).
  maclib::core::log::error "cameracontroller::uninstall: no clean uninstall"
  return 1
}
