#!/usr/bin/env bash
# shellcheck disable=all
# crystalfetch.sh - CrystalFetch (Installomator label) helpers
#
# Vendor source: Installomator label crystalfetch from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::crystalfetch::suite_installer_url() {
  # TODO: Add actual download URL for CrystalFetch
  printf '%s\\n' 'https://example.com/crystalfetch/installer'
}

maclib::media::crystalfetch::latest_version() {
  # TODO: Add version detection for CrystalFetch
  return 1
}

maclib::media::crystalfetch::is_installed() {
  [[ -d "/Applications/Crystalfetch.app" ]] || [[ -d "$HOME/Applications/Crystalfetch.app" ]]
}

maclib::media::crystalfetch::installed_path() {
  if [[ -d "/Applications/Crystalfetch.app" ]]; then
    printf '%s\\n' "/Applications/Crystalfetch.app"
  elif [[ -d "$HOME/Applications/Crystalfetch.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Crystalfetch.app"
  fi
}

maclib::crystalfetch::install() {
  local url tmp mp app
  url="$(maclib::crystalfetch::suite_installer_url)"
  tmp="$(mktemp -d -t "crystalfetch.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "crystalfetch::install: download failed"
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


maclib::media::crystalfetch::update() {
  # No vendor update path documented for "CrystalFetch".
  maclib::core::log::error "crystalfetch::update: no update path"
  return 127
}

maclib::media::crystalfetch::uninstall() {
  # No clean uninstall for "CrystalFetch" (documented constraint).
  maclib::core::log::error "crystalfetch::uninstall: no clean uninstall"
  return 1
}
