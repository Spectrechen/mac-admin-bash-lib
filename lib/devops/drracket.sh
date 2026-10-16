#!/usr/bin/env bash
# shellcheck disable=all
# drracket.sh - DrRacket (Installomator label) helpers
#
# Vendor source: Installomator label drracket from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::drracket::suite_installer_url() {
  # TODO: Add actual download URL for DrRacket
  printf '%s\\n' 'https://example.com/drracket/installer'
}

maclib::devops::drracket::latest_version() {
  # TODO: Add version detection for DrRacket
  return 1
}

maclib::devops::drracket::is_installed() {
  [[ -d "/Applications/Drracket.app" ]] || [[ -d "$HOME/Applications/Drracket.app" ]]
}

maclib::devops::drracket::installed_path() {
  if [[ -d "/Applications/Drracket.app" ]]; then
    printf '%s\\n' "/Applications/Drracket.app"
  elif [[ -d "$HOME/Applications/Drracket.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Drracket.app"
  fi
}

maclib::drracket::install() {
  local url tmp mp app
  url="$(maclib::drracket::suite_installer_url)"
  tmp="$(mktemp -d -t "drracket.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "drracket::install: download failed"
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


maclib::devops::drracket::update() {
  # No vendor update path documented for "DrRacket".
  maclib::core::log::error "drracket::update: no update path"
  return 127
}

maclib::devops::drracket::uninstall() {
  # No clean uninstall for "DrRacket" (documented constraint).
  maclib::core::log::error "drracket::uninstall: no clean uninstall"
  return 1
}
