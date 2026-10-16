#!/usr/bin/env bash
# shellcheck disable=all
# browserosaurus.sh - "Browserosaurus" (Installomator label) helpers
#
# Vendor source: Installomator label browserosaurus from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "Z89KPMLTFR".
# Installer type: "zip".
#

maclib::apps::b::browserosaurus::suite_installer_url() {
  downloadURLFromGit will-stone browserosaurus
}

maclib::apps::b::browserosaurus::latest_version() {
  versionFromGit will-stone browserosaurus
}

maclib::apps::b::browserosaurus::is_installed() {
  [[ -d "/Applications/Browserosaurus.app" ]] || [[ -d "$HOME/Applications/Browserosaurus.app" ]]
}

maclib::apps::b::browserosaurus::installed_path() {
  if [[ -d "/Applications/Browserosaurus.app" ]]; then
    printf "%s\n" "/Applications/Browserosaurus.app"
  elif [[ -d "$HOME/Applications/Browserosaurus.app" ]]; then
    printf "%s\n" "$HOME/Applications/Browserosaurus.app"
  fi
}

maclib::apps::b::browserosaurus::install() {
  local url tmp
  url="$(maclib::apps::b::browserosaurus::suite_installer_url)"
  tmp="$(mktemp -d -t "browserosaurus.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "browserosaurus::install: download failed"
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

maclib::apps::b::browserosaurus::update() {
  # No vendor update path documented for "Browserosaurus".
  maclib::core::log::error "browserosaurus::update: no update path"
  return 127
}

maclib::apps::b::browserosaurus::uninstall() {
  # No clean uninstall for "Browserosaurus" (documented constraint).
  maclib::core::log::error "browserosaurus::uninstall: no clean uninstall"
  return 1
}
