#!/usr/bin/env bash
# shellcheck disable=all
# bettertouchtool.sh - "BetterTouchTool" (Installomator label) helpers
#
# Vendor source: Installomator label bettertouchtool from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "DAFVSXZ82P".
# Installer type: "zip".
#

maclib::apps::b::bettertouchtool::suite_installer_url() {
  https://folivora.ai/releases/BetterTouchTool.zip
}

maclib::apps::b::bettertouchtool::latest_version() {
  curl -fs https://updates.folivora.ai/bettertouchtool_release_notes.html | grep BetterTouchTool | head -n 2 | tail -n 1 | sed -E 's/.* ([0-9\.]*) .*/\1/g'
}

maclib::apps::b::bettertouchtool::is_installed() {
  [[ -d "/Applications/BetterTouchTool.app" ]] || [[ -d "$HOME/Applications/BetterTouchTool.app" ]]
}

maclib::apps::b::bettertouchtool::installed_path() {
  if [[ -d "/Applications/BetterTouchTool.app" ]]; then
    printf "%s\n" "/Applications/BetterTouchTool.app"
  elif [[ -d "$HOME/Applications/BetterTouchTool.app" ]]; then
    printf "%s\n" "$HOME/Applications/BetterTouchTool.app"
  fi
}

maclib::apps::b::bettertouchtool::install() {
  local url tmp
  url="$(maclib::apps::b::bettertouchtool::suite_installer_url)"
  tmp="$(mktemp -d -t "bettertouchtool.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "bettertouchtool::install: download failed"
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

maclib::apps::b::bettertouchtool::update() {
  # No vendor update path documented for "BetterTouchTool".
  maclib::core::log::error "bettertouchtool::update: no update path"
  return 127
}

maclib::apps::b::bettertouchtool::uninstall() {
  # No clean uninstall for "BetterTouchTool" (documented constraint).
  maclib::core::log::error "bettertouchtool::uninstall: no clean uninstall"
  return 1
}
