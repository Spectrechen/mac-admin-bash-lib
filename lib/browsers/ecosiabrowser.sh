#!/usr/bin/env bash
# shellcheck disable=all
# ecosiabrowser.sh - Ecosia Browser (Installomator label) helpers
#
# Vendor source: Installomator label ecosiabrowser from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::browsers::ecosiabrowser::suite_installer_url() {
  # TODO: Add actual download URL for Ecosia Browser
  printf '%s\\n' 'https://example.com/ecosiabrowser/installer'
}

maclib::browsers::ecosiabrowser::latest_version() {
  # TODO: Add version detection for Ecosia Browser
  return 1
}

maclib::browsers::ecosiabrowser::is_installed() {
  [[ -d "/Applications/Ecosia Browser.app" ]] || [[ -d "$HOME/Applications/Ecosia Browser.app" ]]
}

maclib::browsers::ecosiabrowser::installed_path() {
  if [[ -d "/Applications/Ecosia Browser.app" ]]; then
    printf '%s\\n' "/Applications/Ecosia Browser.app"
  elif [[ -d "$HOME/Applications/Ecosia Browser.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ecosia Browser.app"
  fi
}

maclib::ecosiabrowser::install() {
  local url tmp mp app
  url="$(maclib::ecosiabrowser::suite_installer_url)"
  tmp="$(mktemp -d -t "ecosiabrowser.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "ecosiabrowser::install: download failed"
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


maclib::browsers::ecosiabrowser::update() {
  # No vendor update path documented for "Ecosia Browser".
  maclib::core::log::error "ecosiabrowser::update: no update path"
  return 127
}

maclib::browsers::ecosiabrowser::uninstall() {
  # No clean uninstall for "Ecosia Browser" (documented constraint).
  maclib::core::log::error "ecosiabrowser::uninstall: no clean uninstall"
  return 1
}
