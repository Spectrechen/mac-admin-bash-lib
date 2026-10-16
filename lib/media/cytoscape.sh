#!/usr/bin/env bash
# shellcheck disable=all
# cytoscape.sh - Cytoscape (Installomator label) helpers
#
# Vendor source: Installomator label cytoscape from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::media::cytoscape::suite_installer_url() {
  # TODO: Add actual download URL for Cytoscape
  printf '%s\\n' 'https://example.com/cytoscape/installer'
}

maclib::media::cytoscape::latest_version() {
  # TODO: Add version detection for Cytoscape
  return 1
}

maclib::media::cytoscape::is_installed() {
  [[ -d "/Applications/Cytoscape.app" ]] || [[ -d "$HOME/Applications/Cytoscape.app" ]]
}

maclib::media::cytoscape::installed_path() {
  if [[ -d "/Applications/Cytoscape.app" ]]; then
    printf '%s\\n' "/Applications/Cytoscape.app"
  elif [[ -d "$HOME/Applications/Cytoscape.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cytoscape.app"
  fi
}

maclib::cytoscape::install() {
  local url tmp mp app
  url="$(maclib::cytoscape::suite_installer_url)"
  tmp="$(mktemp -d -t "cytoscape.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cytoscape::install: download failed"
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


maclib::media::cytoscape::update() {
  # No vendor update path documented for "Cytoscape".
  maclib::core::log::error "cytoscape::update: no update path"
  return 127
}

maclib::media::cytoscape::uninstall() {
  # No clean uninstall for "Cytoscape" (documented constraint).
  maclib::core::log::error "cytoscape::uninstall: no clean uninstall"
  return 1
}
