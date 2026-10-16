#!/usr/bin/env bash
# shellcheck disable=all
# cormorant.sh - Cormorant (Installomator label) helpers
#
# Vendor source: Installomator label cormorant from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/c::cormorant::suite_installer_url() {
  # TODO: Add actual download URL for Cormorant
  printf '%s\\n' 'https://example.com/cormorant/installer'
}

maclib::apps/c::cormorant::latest_version() {
  # TODO: Add version detection for Cormorant
  return 1
}

maclib::apps/c::cormorant::is_installed() {
  [[ -d "/Applications/Cormorant.app" ]] || [[ -d "$HOME/Applications/Cormorant.app" ]]
}

maclib::apps/c::cormorant::installed_path() {
  if [[ -d "/Applications/Cormorant.app" ]]; then
    printf '%s\\n' "/Applications/Cormorant.app"
  elif [[ -d "$HOME/Applications/Cormorant.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cormorant.app"
  fi
}

maclib::cormorant::install() {
  local url tmp
  url="$(maclib::cormorant::suite_installer_url)"
  tmp="$(mktemp -d -t "cormorant.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "cormorant::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::apps/c::cormorant::update() {
  # No vendor update path documented for "Cormorant".
  maclib::core::log::error "cormorant::update: no update path"
  return 127
}

maclib::apps/c::cormorant::uninstall() {
  # No clean uninstall for "Cormorant" (documented constraint).
  maclib::core::log::error "cormorant::uninstall: no clean uninstall"
  return 1
}
