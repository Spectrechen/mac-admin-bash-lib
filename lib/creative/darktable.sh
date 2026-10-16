#!/usr/bin/env bash
# shellcheck disable=all
# darktable.sh - darktable (Installomator label) helpers
#
# Vendor source: Installomator label darktable from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::creative::darktable::suite_installer_url() {
  # TODO: Add actual download URL for darktable
  printf '%s\\n' 'https://example.com/darktable/installer'
}

maclib::creative::darktable::latest_version() {
  # TODO: Add version detection for darktable
  return 1
}

maclib::creative::darktable::is_installed() {
  [[ -d "/Applications/Darktable.app" ]] || [[ -d "$HOME/Applications/Darktable.app" ]]
}

maclib::creative::darktable::installed_path() {
  if [[ -d "/Applications/Darktable.app" ]]; then
    printf '%s\\n' "/Applications/Darktable.app"
  elif [[ -d "$HOME/Applications/Darktable.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Darktable.app"
  fi
}

maclib::darktable::install() {
  local url tmp mp app
  url="$(maclib::darktable::suite_installer_url)"
  tmp="$(mktemp -d -t "darktable.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "darktable::install: download failed"
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


maclib::creative::darktable::update() {
  # No vendor update path documented for "darktable".
  maclib::core::log::error "darktable::update: no update path"
  return 127
}

maclib::creative::darktable::uninstall() {
  # No clean uninstall for "darktable" (documented constraint).
  maclib::core::log::error "darktable::uninstall: no clean uninstall"
  return 1
}
