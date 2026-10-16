#!/usr/bin/env bash
# shellcheck disable=all
# evernote.sh - Evernote (Installomator label) helpers
#
# Vendor source: Installomator label evernote from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::evernote::suite_installer_url() {
  # TODO: Add actual download URL for Evernote
  printf '%s\\n' 'https://example.com/evernote/installer'
}

maclib::productivity::evernote::latest_version() {
  # TODO: Add version detection for Evernote
  return 1
}

maclib::productivity::evernote::is_installed() {
  [[ -d "/Applications/Evernote.app" ]] || [[ -d "$HOME/Applications/Evernote.app" ]]
}

maclib::productivity::evernote::installed_path() {
  if [[ -d "/Applications/Evernote.app" ]]; then
    printf '%s\\n' "/Applications/Evernote.app"
  elif [[ -d "$HOME/Applications/Evernote.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Evernote.app"
  fi
}

maclib::evernote::install() {
  local url tmp mp app
  url="$(maclib::evernote::suite_installer_url)"
  tmp="$(mktemp -d -t "evernote.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "evernote::install: download failed"
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


maclib::productivity::evernote::update() {
  # No vendor update path documented for "Evernote".
  maclib::core::log::error "evernote::update: no update path"
  return 127
}

maclib::productivity::evernote::uninstall() {
  # No clean uninstall for "Evernote" (documented constraint).
  maclib::core::log::error "evernote::uninstall: no clean uninstall"
  return 1
}
