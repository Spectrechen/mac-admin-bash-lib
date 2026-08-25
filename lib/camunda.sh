#!/usr/bin/env bash
# shellcheck disable=all
# camunda.sh - "Camunda Modeler" (Installomator label) helpers
#
# Vendor source: Installomator label camunda from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "3JVGD57JQZ".
# Installer type: "dmg".
#

maclib::camunda::suite_installer_url() {
  curl -fs https://camunda.com/download/modeler/ | sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep x64.dmg
}

maclib::camunda::latest_version() {
  local downloadURL
  downloadURL="$(curl -fs https://camunda.com/download/modeler/ | sed -n 's/.*href="\([^"]*\)".*/\1/p' | grep x64.dmg)"
  echo "${downloadURL}" | sed 's/.*release\/camunda-modeler\/\([^\/]*\)\/camunda-modeler-.*/\1/'
}

maclib::camunda::is_installed() {
  [[ -d "/Applications/CamundaModeler.app" ]] || [[ -d "$HOME/Applications/CamundaModeler.app" ]]
}

maclib::camunda::installed_path() {
  if [[ -d "/Applications/CamundaModeler.app" ]]; then
    printf "%s\n" "/Applications/CamundaModeler.app"
  elif [[ -d "$HOME/Applications/CamundaModeler.app" ]]; then
    printf "%s\n" "$HOME/Applications/CamundaModeler.app"
  fi
}

maclib::camunda::install() {
  local url tmp
  url="$(maclib::camunda::suite_installer_url)"
  tmp="$(mktemp -d -t "camunda.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "camunda::install: download failed"
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

maclib::camunda::update() {
  # No vendor update path documented for "Camunda Modeler".
  maclib::log::error "camunda::update: no update path"
  return 127
}

maclib::camunda::uninstall() {
  # No clean uninstall for "Camunda Modeler" (documented constraint).
  maclib::log::error "camunda::uninstall: no clean uninstall"
  return 1
}
