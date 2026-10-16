#!/usr/bin/env bash
# shellcheck disable=all
# elasticvue.sh - elasticvue (Installomator label) helpers
#
# Vendor source: Installomator label elasticvue from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::elasticvue::suite_installer_url() {
  # TODO: Add actual download URL for elasticvue
  printf '%s\\n' 'https://example.com/elasticvue/installer'
}

maclib::devops::elasticvue::latest_version() {
  # TODO: Add version detection for elasticvue
  return 1
}

maclib::devops::elasticvue::is_installed() {
  [[ -d "/Applications/Elasticvue.app" ]] || [[ -d "$HOME/Applications/Elasticvue.app" ]]
}

maclib::devops::elasticvue::installed_path() {
  if [[ -d "/Applications/Elasticvue.app" ]]; then
    printf '%s\\n' "/Applications/Elasticvue.app"
  elif [[ -d "$HOME/Applications/Elasticvue.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Elasticvue.app"
  fi
}

maclib::elasticvue::install() {
  local url tmp mp app
  url="$(maclib::elasticvue::suite_installer_url)"
  tmp="$(mktemp -d -t "elasticvue.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "elasticvue::install: download failed"
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


maclib::devops::elasticvue::update() {
  # No vendor update path documented for "elasticvue".
  maclib::core::log::error "elasticvue::update: no update path"
  return 127
}

maclib::devops::elasticvue::uninstall() {
  # No clean uninstall for "elasticvue" (documented constraint).
  maclib::core::log::error "elasticvue::uninstall: no clean uninstall"
  return 1
}
