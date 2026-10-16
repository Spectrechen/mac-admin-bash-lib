#!/usr/bin/env bash
# shellcheck disable=all
# exifrenamer.sh - ExifRenamer (Installomator label) helpers
#
# Vendor source: Installomator label exifrenamer from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::exifrenamer::suite_installer_url() {
  # TODO: Add actual download URL for ExifRenamer
  printf '%s\\n' 'https://example.com/exifrenamer/installer'
}

maclib::media::exifrenamer::latest_version() {
  # TODO: Add version detection for ExifRenamer
  return 1
}

maclib::media::exifrenamer::is_installed() {
  [[ -d "/Applications/Exifrenamer.app" ]] || [[ -d "$HOME/Applications/Exifrenamer.app" ]]
}

maclib::media::exifrenamer::installed_path() {
  if [[ -d "/Applications/Exifrenamer.app" ]]; then
    printf '%s\\n' "/Applications/Exifrenamer.app"
  elif [[ -d "$HOME/Applications/Exifrenamer.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Exifrenamer.app"
  fi
}

maclib::exifrenamer::install() {
  local url tmp mp app
  url="$(maclib::exifrenamer::suite_installer_url)"
  tmp="$(mktemp -d -t "exifrenamer.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "exifrenamer::install: download failed"
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


maclib::media::exifrenamer::update() {
  # No vendor update path documented for "ExifRenamer".
  maclib::core::log::error "exifrenamer::update: no update path"
  return 127
}

maclib::media::exifrenamer::uninstall() {
  # No clean uninstall for "ExifRenamer" (documented constraint).
  maclib::core::log::error "exifrenamer::uninstall: no clean uninstall"
  return 1
}
