#!/usr/bin/env bash
# shellcheck disable=all
# balenaetcher.sh - "balenaEtcher" (Installomator label) helpers
#
# Vendor source: Installomator label balenaetcher from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "66H43P8FRG".
# Installer type: "dmg".
#

maclib::balenaetcher::suite_installer_url() {
  downloadURLFromGit balena-io etcher
}

maclib::balenaetcher::latest_version() {
  versionFromGit balena-io etcher
}

maclib::balenaetcher::is_installed() {
  [[ -d "/Applications/balenaEtcher.app" ]] || [[ -d "$HOME/Applications/balenaEtcher.app" ]]
}

maclib::balenaetcher::installed_path() {
  if [[ -d "/Applications/balenaEtcher.app" ]]; then
    printf "%s\n" "/Applications/balenaEtcher.app"
  elif [[ -d "$HOME/Applications/balenaEtcher.app" ]]; then
    printf "%s\n" "$HOME/Applications/balenaEtcher.app"
  fi
}

maclib::balenaetcher::install() {
  local url tmp
  url="$(maclib::balenaetcher::suite_installer_url)"
  tmp="$(mktemp -d -t "balenaetcher.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "balenaetcher::install: download failed"
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

maclib::balenaetcher::update() {
  # No vendor update path documented for "balenaEtcher".
  maclib::log::error "balenaetcher::update: no update path"
  return 127
}

maclib::balenaetcher::uninstall() {
  # No clean uninstall for "balenaEtcher" (documented constraint).
  maclib::log::error "balenaetcher::uninstall: no clean uninstall"
  return 1
}
