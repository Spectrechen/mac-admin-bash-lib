#!/usr/bin/env bash
# shellcheck disable=all
# colourcontrastanalyser.sh - Colour Contrast Analyser (Installomator label) helpers
#
# Vendor source: Installomator label colourcontrastanalyser from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/c::colourcontrastanalyser::suite_installer_url() {
  # TODO: Add actual download URL for Colour Contrast Analyser
  printf '%s\\n' 'https://example.com/colourcontrastanalyser/installer'
}

maclib::apps/c::colourcontrastanalyser::latest_version() {
  # TODO: Add version detection for Colour Contrast Analyser
  return 1
}

maclib::apps/c::colourcontrastanalyser::is_installed() {
  [[ -d "/Applications/Colour Contrast Analyser.app" ]] || [[ -d "$HOME/Applications/Colour Contrast Analyser.app" ]]
}

maclib::apps/c::colourcontrastanalyser::installed_path() {
  if [[ -d "/Applications/Colour Contrast Analyser.app" ]]; then
    printf '%s\\n' "/Applications/Colour Contrast Analyser.app"
  elif [[ -d "$HOME/Applications/Colour Contrast Analyser.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Colour Contrast Analyser.app"
  fi
}

maclib::colourcontrastanalyser::install() {
  local url tmp mp app
  url="$(maclib::colourcontrastanalyser::suite_installer_url)"
  tmp="$(mktemp -d -t "colourcontrastanalyser.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "colourcontrastanalyser::install: download failed"
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


maclib::apps/c::colourcontrastanalyser::update() {
  # No vendor update path documented for "Colour Contrast Analyser".
  maclib::core::log::error "colourcontrastanalyser::update: no update path"
  return 127
}

maclib::apps/c::colourcontrastanalyser::uninstall() {
  # No clean uninstall for "Colour Contrast Analyser" (documented constraint).
  maclib::core::log::error "colourcontrastanalyser::uninstall: no clean uninstall"
  return 1
}
