#!/usr/bin/env bash
# shellcheck disable=all
# exelbanstats.sh - Stats (Installomator label) helpers
#
# Vendor source: Installomator label exelbanstats from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::productivity::exelbanstats::suite_installer_url() {
  # TODO: Add actual download URL for Stats
  printf '%s\\n' 'https://example.com/exelbanstats/installer'
}

maclib::productivity::exelbanstats::latest_version() {
  # TODO: Add version detection for Stats
  return 1
}

maclib::productivity::exelbanstats::is_installed() {
  [[ -d "/Applications/Stats.app" ]] || [[ -d "$HOME/Applications/Stats.app" ]]
}

maclib::productivity::exelbanstats::installed_path() {
  if [[ -d "/Applications/Stats.app" ]]; then
    printf '%s\\n' "/Applications/Stats.app"
  elif [[ -d "$HOME/Applications/Stats.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Stats.app"
  fi
}

maclib::exelbanstats::install() {
  local url tmp mp app
  url="$(maclib::exelbanstats::suite_installer_url)"
  tmp="$(mktemp -d -t "exelbanstats.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "exelbanstats::install: download failed"
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


maclib::productivity::exelbanstats::update() {
  # No vendor update path documented for "Stats".
  maclib::core::log::error "exelbanstats::update: no update path"
  return 127
}

maclib::productivity::exelbanstats::uninstall() {
  # No clean uninstall for "Stats" (documented constraint).
  maclib::core::log::error "exelbanstats::uninstall: no clean uninstall"
  return 1
}
