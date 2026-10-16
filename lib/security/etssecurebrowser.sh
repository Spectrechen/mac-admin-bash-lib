#!/usr/bin/env bash
# shellcheck disable=all
# etssecurebrowser.sh - ETS Secure Browser (Installomator label) helpers
#
# Vendor source: Installomator label etssecurebrowser from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::security::etssecurebrowser::suite_installer_url() {
  # TODO: Add actual download URL for ETS Secure Browser
  printf '%s\\n' 'https://example.com/etssecurebrowser/installer'
}

maclib::security::etssecurebrowser::latest_version() {
  # TODO: Add version detection for ETS Secure Browser
  return 1
}

maclib::security::etssecurebrowser::is_installed() {
  [[ -d "/Applications/Ets Secure Browser.app" ]] || [[ -d "$HOME/Applications/Ets Secure Browser.app" ]]
}

maclib::security::etssecurebrowser::installed_path() {
  if [[ -d "/Applications/Ets Secure Browser.app" ]]; then
    printf '%s\\n' "/Applications/Ets Secure Browser.app"
  elif [[ -d "$HOME/Applications/Ets Secure Browser.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Ets Secure Browser.app"
  fi
}

maclib::etssecurebrowser::install() {
  local url tmp mp app
  url="$(maclib::etssecurebrowser::suite_installer_url)"
  tmp="$(mktemp -d -t "etssecurebrowser.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "etssecurebrowser::install: download failed"
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


maclib::security::etssecurebrowser::update() {
  # No vendor update path documented for "ETS Secure Browser".
  maclib::core::log::error "etssecurebrowser::update: no update path"
  return 127
}

maclib::security::etssecurebrowser::uninstall() {
  # No clean uninstall for "ETS Secure Browser" (documented constraint).
  maclib::core::log::error "etssecurebrowser::uninstall: no clean uninstall"
  return 1
}
