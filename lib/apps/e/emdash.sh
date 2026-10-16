#!/usr/bin/env bash
# shellcheck disable=all
# emdash.sh - Emdash (Installomator label) helpers
#
# Vendor source: Installomator label emdash from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/e::emdash::suite_installer_url() {
  # TODO: Add actual download URL for Emdash
  printf '%s\\n' 'https://example.com/emdash/installer'
}

maclib::apps/e::emdash::latest_version() {
  # TODO: Add version detection for Emdash
  return 1
}

maclib::apps/e::emdash::is_installed() {
  [[ -d "/Applications/Emdash.app" ]] || [[ -d "$HOME/Applications/Emdash.app" ]]
}

maclib::apps/e::emdash::installed_path() {
  if [[ -d "/Applications/Emdash.app" ]]; then
    printf '%s\\n' "/Applications/Emdash.app"
  elif [[ -d "$HOME/Applications/Emdash.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Emdash.app"
  fi
}

maclib::emdash::install() {
  local url tmp mp app
  url="$(maclib::emdash::suite_installer_url)"
  tmp="$(mktemp -d -t "emdash.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "emdash::install: download failed"
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


maclib::apps/e::emdash::update() {
  # No vendor update path documented for "Emdash".
  maclib::core::log::error "emdash::update: no update path"
  return 127
}

maclib::apps/e::emdash::uninstall() {
  # No clean uninstall for "Emdash" (documented constraint).
  maclib::core::log::error "emdash::uninstall: no clean uninstall"
  return 1
}
