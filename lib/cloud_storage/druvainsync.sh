#!/usr/bin/env bash
# shellcheck disable=all
# druvainsync.sh - Druva inSync (Installomator label) helpers
#
# Vendor source: Installomator label druvainsync from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInDmg".
#

maclib::cloud_storage::druvainsync::suite_installer_url() {
  # TODO: Add actual download URL for Druva inSync
  printf '%s\\n' 'https://example.com/druvainsync/installer'
}

maclib::cloud_storage::druvainsync::latest_version() {
  # TODO: Add version detection for Druva inSync
  return 1
}

maclib::cloud_storage::druvainsync::is_installed() {
  [[ -d "/Applications/Druva Insync.app" ]] || [[ -d "$HOME/Applications/Druva Insync.app" ]]
}

maclib::cloud_storage::druvainsync::installed_path() {
  if [[ -d "/Applications/Druva Insync.app" ]]; then
    printf '%s\\n' "/Applications/Druva Insync.app"
  elif [[ -d "$HOME/Applications/Druva Insync.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Druva Insync.app"
  fi
}

maclib::druvainsync::install() {
  local url tmp mp pkg_path
  url="$(maclib::druvainsync::suite_installer_url)"
  tmp="$(mktemp -d -t "druvainsync.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "druvainsync::install: download failed"
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
    maclib::core::log::error "druvainsync::install: no .pkg found in DMG"
  fi
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::cloud_storage::druvainsync::update() {
  # No vendor update path documented for "Druva inSync".
  maclib::core::log::error "druvainsync::update: no update path"
  return 127
}

maclib::cloud_storage::druvainsync::uninstall() {
  # No clean uninstall for "Druva inSync" (documented constraint).
  maclib::core::log::error "druvainsync::uninstall: no clean uninstall"
  return 1
}
