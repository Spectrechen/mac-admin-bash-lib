#!/usr/bin/env bash
# shellcheck disable=all
# bettertouchtool.sh - "BetterTouchTool" (Installomator label) helpers
#
# Vendor source: Installomator label bettertouchtool from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "DAFVSXZ82P".
# Installer type: "zip".
#

maclib::bettertouchtool::suite_installer_url() {
  https://folivora.ai/releases/BetterTouchTool.zip
}

maclib::bettertouchtool::latest_version() {
  curl -fs https://updates.folivora.ai/bettertouchtool_release_notes.html | grep BetterTouchTool | head -n 2 | tail -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g'
}

maclib::bettertouchtool::is_installed() {
  [[ -d "/Applications/BetterTouchTool.app" ]] || [[ -d "$HOME/Applications/BetterTouchTool.app" ]]
}

maclib::bettertouchtool::installed_path() {
  if [[ -d "/Applications/BetterTouchTool.app" ]]; then
    printf "%s\n" "/Applications/BetterTouchTool.app"
  elif [[ -d "$HOME/Applications/BetterTouchTool.app" ]]; then
    printf "%s\n" "$HOME/Applications/BetterTouchTool.app"
  fi
}

maclib::bettertouchtool::install() {
  local url tmp
  url="$(maclib::bettertouchtool::suite_installer_url)"
  tmp="$(mktemp -d -t "bettertouchtool.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "bettertouchtool::install: download failed"
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

maclib::bettertouchtool::update() {
  # No vendor update path documented for "BetterTouchTool".
  maclib::log::error "bettertouchtool::update: no update path"
  return 127
}

maclib::bettertouchtool::uninstall() {
  # No clean uninstall for "BetterTouchTool" (documented constraint).
  maclib::log::error "bettertouchtool::uninstall: no clean uninstall"
  return 1
}
