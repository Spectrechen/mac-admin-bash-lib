#!/usr/bin/env bash
# shellcheck disable=all
# automounter.sh - "AutoMounter" (Installomator label) helpers
#
# Vendor source: Installomator label automounter from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "UKWABN4MGL".
# Installer type: "dmg".
#

maclib::automounter::suite_installer_url() {
  https://www.pixeleyes.co.nz/automounter/AutoMounter.dmg
}

maclib::automounter::latest_version() {
  curl -fs https://www.pixeleyes.co.nz/automounter/version
}

maclib::automounter::is_installed() {
  [[ -d "/Applications/AutoMounter.app" ]] || [[ -d "$HOME/Applications/AutoMounter.app" ]]
}

maclib::automounter::installed_path() {
  if [[ -d "/Applications/AutoMounter.app" ]]; then
    printf "%s\n" "/Applications/AutoMounter.app"
  elif [[ -d "$HOME/Applications/AutoMounter.app" ]]; then
    printf "%s\n" "$HOME/Applications/AutoMounter.app"
  fi
}

maclib::automounter::install() {
  local url tmp
  url="$(maclib::automounter::suite_installer_url)"
  tmp="$(mktemp -d -t "automounter.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "automounter::install: download failed"
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

maclib::automounter::update() {
  # No vendor update path documented for "AutoMounter".
  maclib::log::error "automounter::update: no update path"
  return 127
}

maclib::automounter::uninstall() {
  # No clean uninstall for "AutoMounter" (documented constraint).
  maclib::log::error "automounter::uninstall: no clean uninstall"
  return 1
}
