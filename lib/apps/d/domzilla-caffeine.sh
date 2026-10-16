#!/usr/bin/env bash
# shellcheck disable=all
# domzilla-caffeine.sh - Caffeine (Installomator label) helpers
#
# Vendor source: Installomator label domzilla-caffeine from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::apps/d::domzilla-caffeine::suite_installer_url() {
  # TODO: Add actual download URL for Caffeine
  printf '%s\\n' 'https://example.com/domzilla-caffeine/installer'
}

maclib::apps/d::domzilla-caffeine::latest_version() {
  # TODO: Add version detection for Caffeine
  return 1
}

maclib::apps/d::domzilla-caffeine::is_installed() {
  [[ -d "/Applications/Caffeine.app" ]] || [[ -d "$HOME/Applications/Caffeine.app" ]]
}

maclib::apps/d::domzilla-caffeine::installed_path() {
  if [[ -d "/Applications/Caffeine.app" ]]; then
    printf '%s\\n' "/Applications/Caffeine.app"
  elif [[ -d "$HOME/Applications/Caffeine.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Caffeine.app"
  fi
}

maclib::domzilla-caffeine::install() {
  local url tmp
  url="$(maclib::domzilla-caffeine::suite_installer_url)"
  tmp="$(mktemp -d -t "domzilla-caffeine.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "domzilla-caffeine::install: download failed"
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


maclib::apps/d::domzilla-caffeine::update() {
  # No vendor update path documented for "Caffeine".
  maclib::core::log::error "domzilla-caffeine::update: no update path"
  return 127
}

maclib::apps/d::domzilla-caffeine::uninstall() {
  # No clean uninstall for "Caffeine" (documented constraint).
  maclib::core::log::error "domzilla-caffeine::uninstall: no clean uninstall"
  return 1
}
