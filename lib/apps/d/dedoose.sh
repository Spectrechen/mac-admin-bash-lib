#!/usr/bin/env bash
# shellcheck disable=all
# dedoose.sh - Dedoose (Installomator label) helpers
#
# Vendor source: Installomator label dedoose from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::dedoose::suite_installer_url() {
  # TODO: Add actual download URL for Dedoose
  printf '%s\\n' 'https://example.com/dedoose/installer'
}

maclib::apps/d::dedoose::latest_version() {
  # TODO: Add version detection for Dedoose
  return 1
}

maclib::apps/d::dedoose::is_installed() {
  [[ -d "/Applications/Dedoose.app" ]] || [[ -d "$HOME/Applications/Dedoose.app" ]]
}

maclib::apps/d::dedoose::installed_path() {
  if [[ -d "/Applications/Dedoose.app" ]]; then
    printf '%s\\n' "/Applications/Dedoose.app"
  elif [[ -d "$HOME/Applications/Dedoose.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dedoose.app"
  fi
}

maclib::dedoose::install() {
  local url tmp mp app
  url="$(maclib::dedoose::suite_installer_url)"
  tmp="$(mktemp -d -t "dedoose.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dedoose::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::apps/d::dedoose::update() {
  # No vendor update path documented for "Dedoose".
  maclib::core::log::error "dedoose::update: no update path"
  return 127
}

maclib::apps/d::dedoose::uninstall() {
  # No clean uninstall for "Dedoose" (documented constraint).
  maclib::core::log::error "dedoose::uninstall: no clean uninstall"
  return 1
}
