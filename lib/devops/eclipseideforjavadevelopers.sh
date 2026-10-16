#!/usr/bin/env bash
# shellcheck disable=all
# eclipseideforjavadevelopers.sh - Eclipse (Installomator label) helpers
#
# Vendor source: Installomator label eclipseideforjavadevelopers from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::devops::eclipseideforjavadevelopers::suite_installer_url() {
  # TODO: Add actual download URL for Eclipse
  printf '%s\\n' 'https://example.com/eclipseideforjavadevelopers/installer'
}

maclib::devops::eclipseideforjavadevelopers::latest_version() {
  # TODO: Add version detection for Eclipse
  return 1
}

maclib::devops::eclipseideforjavadevelopers::is_installed() {
  [[ -d "/Applications/Eclipse.app" ]] || [[ -d "$HOME/Applications/Eclipse.app" ]]
}

maclib::devops::eclipseideforjavadevelopers::installed_path() {
  if [[ -d "/Applications/Eclipse.app" ]]; then
    printf '%s\\n' "/Applications/Eclipse.app"
  elif [[ -d "$HOME/Applications/Eclipse.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Eclipse.app"
  fi
}

maclib::eclipseideforjavadevelopers::install() {
  local url tmp mp app
  url="$(maclib::eclipseideforjavadevelopers::suite_installer_url)"
  tmp="$(mktemp -d -t "eclipseideforjavadevelopers.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "eclipseideforjavadevelopers::install: download failed"
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


maclib::devops::eclipseideforjavadevelopers::update() {
  # No vendor update path documented for "Eclipse".
  maclib::core::log::error "eclipseideforjavadevelopers::update: no update path"
  return 127
}

maclib::devops::eclipseideforjavadevelopers::uninstall() {
  # No clean uninstall for "Eclipse" (documented constraint).
  maclib::core::log::error "eclipseideforjavadevelopers::uninstall: no clean uninstall"
  return 1
}
