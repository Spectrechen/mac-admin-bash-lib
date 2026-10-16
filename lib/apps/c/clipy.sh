#!/usr/bin/env bash
# shellcheck disable=all
# clipy.sh - Clipy (Installomator label) helpers
#
# Vendor source: Installomator label clipy from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
# Vendor: Clipy Project (Open Source)
# App location: /Applications/Clipy.app
# Latest version: 1.2.1 (confirmed via GitHub Releases)
# Download page: https://github.com/Clipy/Clipy
# GitHub Releases: https://github.com/Clipy/Clipy/releases
#
# Notes:
#   - Clipy is free/open-source software (GPLv3).
#   - A clipboard extension app for macOS.
#   - Requires macOS 13 Ventura or later.
#   - Available via Homebrew: brew install --cask clipy
#   - No automatic update mechanism; reinstall latest version to update.

maclib::apps::c::clipy::suite_installer_url() {
  printf '%s\n' 'https://github.com/Clipy/Clipy'
}

maclib::apps::c::clipy::latest_version() {
  # Version 1.2.1 confirmed via GitHub Releases (Clipy/Clipy)
  # Try to fetch latest version from GitHub API
  local ver
  ver=$(curl -fsSL 'https://api.github.com/repos/Clipy/Clipy/releases/latest' 2>/dev/null | \
    grep '"tag_name"' | sed -E 's/.*"v?([0-9.]+)".*/\1/' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback to hardcoded version
  printf '%s\n' '1.2.1'
  return 0
}

maclib::apps::c::clipy::is_installed() {
  [[ -d '/Applications/Clipy.app' ]] || [[ -d "$HOME/Applications/Clipy.app" ]]
}

maclib::apps::c::clipy::installed_path() {
  if [[ -d '/Applications/Clipy.app' ]]; then
    printf '%s\n' '/Applications/Clipy.app'
    return 0
  elif [[ -d "$HOME/Applications/Clipy.app" ]]; then
    printf '%s\n' "$HOME/Applications/Clipy.app"
    return 0
  fi
  return 1
}

maclib::clipy::install() {
  # Clipy DMG download from GitHub Releases.
  # The GitHub Releases page (https://github.com/Clipy/Clipy/releases)
  # provides direct DMG downloads. Requires root for /Applications install.
  local url tmp mp app
  url="https://github.com/Clipy/Clipy/releases/latest"
  tmp="$(mktemp -d -t "clipy.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Get the latest release asset URL
  local dmg_url
  dmg_url=$(curl -fsSL 'https://api.github.com/repos/Clipy/Clipy/releases/latest' 2>/dev/null | \
    grep '"browser_download_url"' | grep '\.dmg' | head -1 | \
    sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')
  if [[ -z "$dmg_url" ]]; then
    maclib::core::log::error "clipy::install: failed to fetch latest release from GitHub"
    return 1
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "clipy::install: failed to download DMG"
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

maclib::apps::c::clipy::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::apps::c::clipy::install "$@"
}

maclib::apps::c::clipy::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Clipy.app'
  rm -rf "$HOME/Library/Application Support/Clipy"
  rm -rf "$HOME/Library/Preferences/org.clipy.plist"
  rm -rf "$HOME/Library/Caches/org.clipy"
  rm -rf "$HOME/Library/Saved Application State/org.clipy.savedState"
  maclib::core::log::info "clipy::uninstall: removed app bundle and support files"
  return 0
}
