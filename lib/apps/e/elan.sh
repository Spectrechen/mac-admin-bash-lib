#!/usr/bin/env bash
# shellcheck disable=all
# elan.sh - ELAN_${appNewVersion} (Installomator label) helpers
#
# Vendor source: Installomator label elan from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/e::elan::suite_installer_url() {
  # TODO: Add actual download URL for ELAN_${appNewVersion}
  printf '%s\\n' 'https://example.com/elan/installer'
}

maclib::apps/e::elan::latest_version() {
  # TODO: Add version detection for ELAN_${appNewVersion}
  return 1
}

maclib::apps/e::elan::is_installed() {
  [[ -d "/Applications/Elan_${Appnewversion}.app" ]] || [[ -d "$HOME/Applications/Elan_${Appnewversion}.app" ]]
}

maclib::apps/e::elan::installed_path() {
  if [[ -d "/Applications/Elan_${Appnewversion}.app" ]]; then
    printf '%s\\n' "/Applications/Elan_${Appnewversion}.app"
  elif [[ -d "$HOME/Applications/Elan_${Appnewversion}.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Elan_${Appnewversion}.app"
  fi
}

maclib::elan::install() {
  local url tmp mp app
  url="$(maclib::elan::suite_installer_url)"
  tmp="$(mktemp -d -t "elan.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "elan::install: download failed"
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


maclib::apps/e::elan::update() {
  # No vendor update path documented for "ELAN_${appNewVersion}".
  maclib::core::log::error "elan::update: no update path"
  return 127
}

maclib::apps/e::elan::uninstall() {
  # No clean uninstall for "ELAN_${appNewVersion}" (documented constraint).
  maclib::core::log::error "elan::uninstall: no clean uninstall"
  return 1
}
