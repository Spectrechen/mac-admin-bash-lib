#!/usr/bin/env bash
# shellcheck disable=all
# examplify.sh - Examplify (Installomator label) helpers
#
# Vendor source: Installomator label examplify from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInDmg".
#

maclib::security::examplify::suite_installer_url() {
  # TODO: Add actual download URL for Examplify
  printf '%s\\n' 'https://example.com/examplify/installer'
}

maclib::security::examplify::latest_version() {
  # TODO: Add version detection for Examplify
  return 1
}

maclib::security::examplify::is_installed() {
  [[ -d "/Applications/Examplify.app" ]] || [[ -d "$HOME/Applications/Examplify.app" ]]
}

maclib::security::examplify::installed_path() {
  if [[ -d "/Applications/Examplify.app" ]]; then
    printf '%s\\n' "/Applications/Examplify.app"
  elif [[ -d "$HOME/Applications/Examplify.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Examplify.app"
  fi
}

maclib::examplify::install() {
  local url tmp mp pkg_path
  url="$(maclib::examplify::suite_installer_url)"
  tmp="$(mktemp -d -t "examplify.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "examplify::install: download failed"
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
    maclib::core::log::error "examplify::install: no .pkg found in DMG"
  fi
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}


maclib::security::examplify::update() {
  # No vendor update path documented for "Examplify".
  maclib::core::log::error "examplify::update: no update path"
  return 127
}

maclib::security::examplify::uninstall() {
  # No clean uninstall for "Examplify" (documented constraint).
  maclib::core::log::error "examplify::uninstall: no clean uninstall"
  return 1
}
