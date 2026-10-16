#!/usr/bin/env bash
# shellcheck disable=all
# dstny.sh - Dstny (Installomator label) helpers
#
# Vendor source: Installomator label dstny from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::dstny::suite_installer_url() {
  # TODO: Add actual download URL for Dstny
  printf '%s\\n' 'https://example.com/dstny/installer'
}

maclib::productivity::dstny::latest_version() {
  # TODO: Add version detection for Dstny
  return 1
}

maclib::productivity::dstny::is_installed() {
  [[ -d "/Applications/Dstny.app" ]] || [[ -d "$HOME/Applications/Dstny.app" ]]
}

maclib::productivity::dstny::installed_path() {
  if [[ -d "/Applications/Dstny.app" ]]; then
    printf '%s\\n' "/Applications/Dstny.app"
  elif [[ -d "$HOME/Applications/Dstny.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Dstny.app"
  fi
}

maclib::dstny::install() {
  local url tmp mp app
  url="$(maclib::dstny::suite_installer_url)"
  tmp="$(mktemp -d -t "dstny.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "dstny::install: download failed"
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


maclib::productivity::dstny::update() {
  # No vendor update path documented for "Dstny".
  maclib::core::log::error "dstny::update: no update path"
  return 127
}

maclib::productivity::dstny::uninstall() {
  # No clean uninstall for "Dstny" (documented constraint).
  maclib::core::log::error "dstny::uninstall: no clean uninstall"
  return 1
}
