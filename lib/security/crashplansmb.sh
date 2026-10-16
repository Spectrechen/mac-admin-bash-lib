#!/usr/bin/env bash
# shellcheck disable=all
# crashplansmb.sh - CrashPlan (Installomator label) helpers
#
# Vendor source: Installomator label crashplansmb from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInDmg".
#

maclib::security::crashplansmb::suite_installer_url() {
  # TODO: Add actual download URL for CrashPlan
  printf '%s\\n' 'https://example.com/crashplansmb/installer'
}

maclib::security::crashplansmb::latest_version() {
  # TODO: Add version detection for CrashPlan
  return 1
}

maclib::security::crashplansmb::is_installed() {
  [[ -d "/Applications/Crashplan.app" ]] || [[ -d "$HOME/Applications/Crashplan.app" ]]
}

maclib::security::crashplansmb::installed_path() {
  if [[ -d "/Applications/Crashplan.app" ]]; then
    printf '%s\\n' "/Applications/Crashplan.app"
  elif [[ -d "$HOME/Applications/Crashplan.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Crashplan.app"
  fi
}

maclib::crashplansmb::install() {
  local url tmp mp pkg_path
  url="$(maclib::crashplansmb::suite_installer_url)"
  tmp="$(mktemp -d -t "crashplansmb.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "crashplansmb::install: download failed"
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
    maclib::core::log::error "crashplansmb::install: no .pkg found in DMG"
  fi
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::security::crashplansmb::update() {
  # No vendor update path documented for "CrashPlan".
  maclib::core::log::error "crashplansmb::update: no update path"
  return 127
}

maclib::security::crashplansmb::uninstall() {
  # No clean uninstall for "CrashPlan" (documented constraint).
  maclib::core::log::error "crashplansmb::uninstall: no clean uninstall"
  return 1
}
