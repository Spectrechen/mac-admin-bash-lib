#!/usr/bin/env bash
# shellcheck disable=all
# coteditor.sh - CotEditor (Installomator label) helpers
#
# Vendor source: Installomator label coteditor from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::coteditor::suite_installer_url() {
  # TODO: Add actual download URL for CotEditor
  printf '%s\\n' 'https://example.com/coteditor/installer'
}

maclib::devops::coteditor::latest_version() {
  # TODO: Add version detection for CotEditor
  return 1
}

maclib::devops::coteditor::is_installed() {
  [[ -d "/Applications/Coteditor.app" ]] || [[ -d "$HOME/Applications/Coteditor.app" ]]
}

maclib::devops::coteditor::installed_path() {
  if [[ -d "/Applications/Coteditor.app" ]]; then
    printf '%s\\n' "/Applications/Coteditor.app"
  elif [[ -d "$HOME/Applications/Coteditor.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Coteditor.app"
  fi
}

maclib::coteditor::install() {
  local url tmp mp app
  url="$(maclib::coteditor::suite_installer_url)"
  tmp="$(mktemp -d -t "coteditor.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "coteditor::install: download failed"
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


maclib::devops::coteditor::update() {
  # No vendor update path documented for "CotEditor".
  maclib::core::log::error "coteditor::update: no update path"
  return 127
}

maclib::devops::coteditor::uninstall() {
  # No clean uninstall for "CotEditor" (documented constraint).
  maclib::core::log::error "coteditor::uninstall: no clean uninstall"
  return 1
}
