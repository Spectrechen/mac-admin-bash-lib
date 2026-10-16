#!/usr/bin/env bash
# shellcheck disable=all
# extensisconnect.sh - Extensis Connect (Installomator label) helpers
#
# Vendor source: Installomator label extensisconnect from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/e::extensisconnect::suite_installer_url() {
  # TODO: Add actual download URL for Extensis Connect
  printf '%s\\n' 'https://example.com/extensisconnect/installer'
}

maclib::apps/e::extensisconnect::latest_version() {
  # TODO: Add version detection for Extensis Connect
  return 1
}

maclib::apps/e::extensisconnect::is_installed() {
  [[ -d "/Applications/Extensis Connect.app" ]] || [[ -d "$HOME/Applications/Extensis Connect.app" ]]
}

maclib::apps/e::extensisconnect::installed_path() {
  if [[ -d "/Applications/Extensis Connect.app" ]]; then
    printf '%s\\n' "/Applications/Extensis Connect.app"
  elif [[ -d "$HOME/Applications/Extensis Connect.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Extensis Connect.app"
  fi
}

maclib::extensisconnect::install() {
  local url tmp mp app
  url="$(maclib::extensisconnect::suite_installer_url)"
  tmp="$(mktemp -d -t "extensisconnect.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "extensisconnect::install: download failed"
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


maclib::apps/e::extensisconnect::update() {
  # No vendor update path documented for "Extensis Connect".
  maclib::core::log::error "extensisconnect::update: no update path"
  return 127
}

maclib::apps/e::extensisconnect::uninstall() {
  # No clean uninstall for "Extensis Connect" (documented constraint).
  maclib::core::log::error "extensisconnect::uninstall: no clean uninstall"
  return 1
}
