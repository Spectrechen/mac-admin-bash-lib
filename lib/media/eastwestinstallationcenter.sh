#!/usr/bin/env bash
# shellcheck disable=all
# eastwestinstallationcenter.sh - EW Installation Center (Installomator label) helpers
#
# Vendor source: Installomator label eastwestinstallationcenter from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkgInZip".
#

maclib::media::eastwestinstallationcenter::suite_installer_url() {
  # TODO: Add actual download URL for EW Installation Center
  printf '%s\\n' 'https://example.com/eastwestinstallationcenter/installer'
}

maclib::media::eastwestinstallationcenter::latest_version() {
  # TODO: Add version detection for EW Installation Center
  return 1
}

maclib::media::eastwestinstallationcenter::is_installed() {
  [[ -d "/Applications/Ew Installation Center.app" ]] || [[ -d "$HOME/Applications/Ew Installation Center.app" ]]
}

maclib::media::eastwestinstallationcenter::installed_path() {
  if [[ -d "/Applications/Ew Installation Center.app" ]]; then
    printf '%s\\n' "/Applications/Ew Installation Center.app"
  elif [[ -d "$HOME/Applications/Ew Installation Center.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ew Installation Center.app"
  fi
}

maclib::eastwestinstallationcenter::install() {
  local url tmp mp app
  url="$(maclib::eastwestinstallationcenter::suite_installer_url)"
  tmp="$(mktemp -d -t "eastwestinstallationcenter.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "eastwestinstallationcenter::install: download failed"
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


maclib::media::eastwestinstallationcenter::update() {
  # No vendor update path documented for "EW Installation Center".
  maclib::core::log::error "eastwestinstallationcenter::update: no update path"
  return 127
}

maclib::media::eastwestinstallationcenter::uninstall() {
  # No clean uninstall for "EW Installation Center" (documented constraint).
  maclib::core::log::error "eastwestinstallationcenter::uninstall: no clean uninstall"
  return 1
}
