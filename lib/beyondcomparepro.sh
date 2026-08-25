#!/usr/bin/env bash
# shellcheck disable=all
# beyondcomparepro.sh - "Beyond Compare" (Installomator label) helpers
#
# Vendor source: Installomator label beyondcomparepro from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "BS29TEJF86".
# Installer type: "zip".
#

maclib::beyondcomparepro::suite_installer_url() {
  echo "${updateFeed}" | xpath 'string(/Update/@download)' 2>/dev/null
}

maclib::beyondcomparepro::latest_version() {
  ${rawVersion// build /.}
}

maclib::beyondcomparepro::is_installed() {
  [[ -d "/Applications/BeyondCompare.app" ]] || [[ -d "$HOME/Applications/BeyondCompare.app" ]]
}

maclib::beyondcomparepro::installed_path() {
  if [[ -d "/Applications/BeyondCompare.app" ]]; then
    printf "%s\n" "/Applications/BeyondCompare.app"
  elif [[ -d "$HOME/Applications/BeyondCompare.app" ]]; then
    printf "%s\n" "$HOME/Applications/BeyondCompare.app"
  fi
}

maclib::beyondcomparepro::install() {
  local url tmp
  url="$(maclib::beyondcomparepro::suite_installer_url)"
  tmp="$(mktemp -d -t "beyondcomparepro.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "beyondcomparepro::install: download failed"
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

maclib::beyondcomparepro::update() {
  # No vendor update path documented for "Beyond Compare".
  maclib::log::error "beyondcomparepro::update: no update path"
  return 127
}

maclib::beyondcomparepro::uninstall() {
  # No clean uninstall for "Beyond Compare" (documented constraint).
  maclib::log::error "beyondcomparepro::uninstall: no clean uninstall"
  return 1
}
