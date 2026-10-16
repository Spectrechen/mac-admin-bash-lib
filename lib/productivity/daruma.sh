#!/usr/bin/env bash
# shellcheck disable=all
# daruma.sh - Daruma (Installomator label) helpers
#
# Vendor source: Installomator label daruma from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::daruma::suite_installer_url() {
  # TODO: Add actual download URL for Daruma
  printf '%s\\n' 'https://example.com/daruma/installer'
}

maclib::productivity::daruma::latest_version() {
  # TODO: Add version detection for Daruma
  return 1
}

maclib::productivity::daruma::is_installed() {
  [[ -d "/Applications/Daruma.app" ]] || [[ -d "$HOME/Applications/Daruma.app" ]]
}

maclib::productivity::daruma::installed_path() {
  if [[ -d "/Applications/Daruma.app" ]]; then
    printf '%s\\n' "/Applications/Daruma.app"
  elif [[ -d "$HOME/Applications/Daruma.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Daruma.app"
  fi
}

maclib::daruma::install() {
  local url tmp mp app
  url="$(maclib::daruma::suite_installer_url)"
  tmp="$(mktemp -d -t "daruma.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "daruma::install: download failed"
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


maclib::productivity::daruma::update() {
  # No vendor update path documented for "Daruma".
  maclib::core::log::error "daruma::update: no update path"
  return 127
}

maclib::productivity::daruma::uninstall() {
  # No clean uninstall for "Daruma" (documented constraint).
  maclib::core::log::error "daruma::uninstall: no clean uninstall"
  return 1
}
