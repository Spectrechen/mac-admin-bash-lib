#!/usr/bin/env bash
# shellcheck disable=all
# digiexam.sh - Digiexam (Installomator label) helpers
#
# Vendor source: Installomator label digiexam from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
#

maclib::apps/d::digiexam::suite_installer_url() {
  # TODO: Add actual download URL for Digiexam
  printf '%s\\n' 'https://example.com/digiexam/installer'
}

maclib::apps/d::digiexam::latest_version() {
  # TODO: Add version detection for Digiexam
  return 1
}

maclib::apps/d::digiexam::is_installed() {
  [[ -d "/Applications/Digiexam.app" ]] || [[ -d "$HOME/Applications/Digiexam.app" ]]
}

maclib::apps/d::digiexam::installed_path() {
  if [[ -d "/Applications/Digiexam.app" ]]; then
    printf '%s\\n' "/Applications/Digiexam.app"
  elif [[ -d "$HOME/Applications/Digiexam.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Digiexam.app"
  fi
}

maclib::digiexam::install() {
  local url tmp mp app
  url="$(maclib::digiexam::suite_installer_url)"
  tmp="$(mktemp -d -t "digiexam.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "digiexam::install: download failed"
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


maclib::apps/d::digiexam::update() {
  # No vendor update path documented for "Digiexam".
  maclib::core::log::error "digiexam::update: no update path"
  return 127
}

maclib::apps/d::digiexam::uninstall() {
  # No clean uninstall for "Digiexam" (documented constraint).
  maclib::core::log::error "digiexam::uninstall: no clean uninstall"
  return 1
}
