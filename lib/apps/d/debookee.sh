#!/usr/bin/env bash
# shellcheck disable=all
# debookee.sh - Debookee (Installomator label) helpers
#
# Vendor source: Installomator label debookee from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/d::debookee::suite_installer_url() {
  # TODO: Add actual download URL for Debookee
  printf '%s\\n' 'https://example.com/debookee/installer'
}

maclib::apps/d::debookee::latest_version() {
  # TODO: Add version detection for Debookee
  return 1
}

maclib::apps/d::debookee::is_installed() {
  [[ -d "/Applications/Debookee.app" ]] || [[ -d "$HOME/Applications/Debookee.app" ]]
}

maclib::apps/d::debookee::installed_path() {
  if [[ -d "/Applications/Debookee.app" ]]; then
    printf '%s\\n' "/Applications/Debookee.app"
  elif [[ -d "$HOME/Applications/Debookee.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Debookee.app"
  fi
}

maclib::debookee::install() {
  local url tmp
  url="$(maclib::debookee::suite_installer_url)"
  tmp="$(mktemp -d -t "debookee.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "debookee::install: download failed"
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


maclib::apps/d::debookee::update() {
  # No vendor update path documented for "Debookee".
  maclib::core::log::error "debookee::update: no update path"
  return 127
}

maclib::apps/d::debookee::uninstall() {
  # No clean uninstall for "Debookee" (documented constraint).
  maclib::core::log::error "debookee::uninstall: no clean uninstall"
  return 1
}
