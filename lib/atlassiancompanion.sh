#!/usr/bin/env bash
# shellcheck disable=all
# atlassiancompanion.sh - "Atlassian Companion" (Installomator label) helpers
#
# Vendor source: Installomator label atlassiancompanion from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "UPXU4CQZ5P".
# Installer type: "dmg".
#

maclib::atlassiancompanion::suite_installer_url() {
  curl -fsL https://confluence.atlassian.com/display/DOC/Install+Atlassian+Companion | sed -nE 's/.*(https:.*\.dmg)\".*/\1/p'
}

maclib::atlassiancompanion::latest_version() {
  getJSONValue "$(curl -fsL https://update-nucleus.atlassian.com/Atlassian-Companion/291cb34fe2296e5fb82b83a04704c9b4/darwin/x64/RELEASES.json)" "currentRelease"
}

maclib::atlassiancompanion::is_installed() {
  [[ -d "/Applications/AtlassianCompanion.app" ]] || [[ -d "$HOME/Applications/AtlassianCompanion.app" ]]
}

maclib::atlassiancompanion::installed_path() {
  if [[ -d "/Applications/AtlassianCompanion.app" ]]; then
    printf "%s\n" "/Applications/AtlassianCompanion.app"
  elif [[ -d "$HOME/Applications/AtlassianCompanion.app" ]]; then
    printf "%s\n" "$HOME/Applications/AtlassianCompanion.app"
  fi
}

maclib::atlassiancompanion::install() {
  local url tmp
  url="$(maclib::atlassiancompanion::suite_installer_url)"
  tmp="$(mktemp -d -t "atlassiancompanion.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "atlassiancompanion::install: download failed"
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

maclib::atlassiancompanion::update() {
  # No vendor update path documented for "Atlassian Companion".
  maclib::log::error "atlassiancompanion::update: no update path"
  return 127
}

maclib::atlassiancompanion::uninstall() {
  # No clean uninstall for "Atlassian Companion" (documented constraint).
  maclib::log::error "atlassiancompanion::uninstall: no clean uninstall"
  return 1
}
