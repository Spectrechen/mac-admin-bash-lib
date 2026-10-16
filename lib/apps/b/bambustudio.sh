#!/usr/bin/env bash
# shellcheck disable=all
# bambustudio.sh - "BambuStudio" (Installomator label) helpers
#
# Vendor source: Installomator label bambustudio from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "T3UBR9Y3B2".
# Installer type: "dmg".
#

maclib::apps::b::bambustudio::suite_installer_url() {
  downloadURLFromGit "bambulab" "BambuStudio"
}

maclib::apps::b::bambustudio::latest_version() {
  versionFromGit "bambulab" "BambuStudio"
}

maclib::apps::b::bambustudio::is_installed() {
  [[ -d "/Applications/BambuStudio.app" ]] || [[ -d "$HOME/Applications/BambuStudio.app" ]]
}

maclib::apps::b::bambustudio::installed_path() {
  if [[ -d "/Applications/BambuStudio.app" ]]; then
    printf "%s\n" "/Applications/BambuStudio.app"
  elif [[ -d "$HOME/Applications/BambuStudio.app" ]]; then
    printf "%s\n" "$HOME/Applications/BambuStudio.app"
  fi
}

maclib::apps::b::bambustudio::install() {
  local url tmp
  url="$(maclib::apps::b::bambustudio::suite_installer_url)"
  tmp="$(mktemp -d -t "bambustudio.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "bambustudio::install: download failed"
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

maclib::apps::b::bambustudio::update() {
  # No vendor update path documented for "BambuStudio".
  maclib::core::log::error "bambustudio::update: no update path"
  return 127
}

maclib::apps::b::bambustudio::uninstall() {
  # No clean uninstall for "BambuStudio" (documented constraint).
  maclib::core::log::error "bambustudio::uninstall: no clean uninstall"
  return 1
}
