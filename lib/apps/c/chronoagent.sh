#!/usr/bin/env bash
# shellcheck disable=all
# chronoagent.sh - "ChronoAgent" (Installomator label) helpers
#
# Vendor source: Installomator label chronoagent from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "unknown".
# Package ID: "com.econtechnologies.ChronoAgent".
# Installer type: "pkg".
#

maclib::apps::c::chronoagent::suite_installer_url() {
  https://www.econtechnologies.com/downloads/ChronoAgent.dmg
}

maclib::apps::c::chronoagent::latest_version() {
  curl -fs https://www.econtechnologies.com/downloads/downloads.html | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs
}

maclib::apps::c::chronoagent::is_installed() {
  pkgutil --pkg-info "com.econtechnologies.ChronoAgent" >/dev/null 2>&1
}

maclib::apps::c::chronoagent::installed_path() {
  local p
  p="$(pkgutil --pkg-info "com.econtechnologies.ChronoAgent" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::apps::c::chronoagent::install() {
  local url tmp
  url="$(maclib::apps::c::chronoagent::suite_installer_url)"
  tmp="$(mktemp -d -t "chronoagent.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "chronoagent::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::apps::c::chronoagent::update() {
# Update: download latest from store page and install.
  maclib::core::log::info "maclib::apps::c::chronoagent::update: download from https://www.econtechnologies.com/downloads/ChronoAgent.dmg"
  # Update via install() which fetches latest from suite_installer_url.
  maclib::core::log::info "maclib::apps::c::chronoagent::update: run install() to get latest"
  maclib::apps::c::chronoagent::install
}
}

maclib::apps::c::chronoagent::uninstall() {
  # No clean uninstall for "ChronoAgent"; removing package receipt "com.econtechnologies.ChronoAgent".
  pkgutil --forget "com.econtechnologies.ChronoAgent"
  return $?
}
}
