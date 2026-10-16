#!/usr/bin/env bash
# shellcheck disable=all
# epsonprintlayout.sh - Epson Print Layout (Installomator label) helpers
#
# Vendor source: Installomator label epsonprintlayout from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInDmg".
#

maclib::media::epsonprintlayout::suite_installer_url() {
  # TODO: Add actual download URL for Epson Print Layout
  printf '%s\\n' 'https://example.com/epsonprintlayout/installer'
}

maclib::media::epsonprintlayout::latest_version() {
  # TODO: Add version detection for Epson Print Layout
  return 1
}

maclib::media::epsonprintlayout::is_installed() {
  [[ -d "/Applications/Epson Print Layout.app" ]] || [[ -d "$HOME/Applications/Epson Print Layout.app" ]]
}

maclib::media::epsonprintlayout::installed_path() {
  if [[ -d "/Applications/Epson Print Layout.app" ]]; then
    printf '%s\\n' "/Applications/Epson Print Layout.app"
  elif [[ -d "$HOME/Applications/Epson Print Layout.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Epson Print Layout.app"
  fi
}

maclib::epsonprintlayout::install() {
  local url tmp mp pkg_path
  url="$(maclib::epsonprintlayout::suite_installer_url)"
  tmp="$(mktemp -d -t "epsonprintlayout.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "epsonprintlayout::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  pkg_path="$(find "$mp" -name "*.pkg" | head -n1)"
  if [[ -n "$pkg_path" ]]; then
    /usr/sbin/installer -pkg "$pkg_path" -target "$@"
    rc=$?
  else
    rc=1
    maclib::core::log::error "epsonprintlayout::install: no .pkg found in DMG"
  fi
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::media::epsonprintlayout::update() {
  # No vendor update path documented for "Epson Print Layout".
  maclib::core::log::error "epsonprintlayout::update: no update path"
  return 127
}

maclib::media::epsonprintlayout::uninstall() {
  # No clean uninstall for "Epson Print Layout" (documented constraint).
  maclib::core::log::error "epsonprintlayout::uninstall: no clean uninstall"
  return 1
}
