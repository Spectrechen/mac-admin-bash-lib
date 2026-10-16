#!/usr/bin/env bash
# shellcheck disable=all
# element.sh - Element (Installomator label) helpers
#
# Vendor source: Installomator label element from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::communication::element::suite_installer_url() {
  # TODO: Add actual download URL for Element
  printf '%s\\n' 'https://example.com/element/installer'
}

maclib::communication::element::latest_version() {
  # TODO: Add version detection for Element
  return 1
}

maclib::communication::element::is_installed() {
  [[ -d "/Applications/Element.app" ]] || [[ -d "$HOME/Applications/Element.app" ]]
}

maclib::communication::element::installed_path() {
  if [[ -d "/Applications/Element.app" ]]; then
    printf '%s\\n' "/Applications/Element.app"
  elif [[ -d "$HOME/Applications/Element.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Element.app"
  fi
}

maclib::element::install() {
  local url tmp mp app
  url="$(maclib::element::suite_installer_url)"
  tmp="$(mktemp -d -t "element.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "element::install: download failed"
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


maclib::communication::element::update() {
  # No vendor update path documented for "Element".
  maclib::core::log::error "element::update: no update path"
  return 127
}

maclib::communication::element::uninstall() {
  # No clean uninstall for "Element" (documented constraint).
  maclib::core::log::error "element::uninstall: no clean uninstall"
  return 1
}
