#!/usr/bin/env bash
# shellcheck disable=all
# clickup.sh - ClickUp (Installomator label) helpers
#
# Vendor source: Installomator label clickup from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
# Vendor: ClickUp Inc.
# App location: /Applications/ClickUp.app
# Latest version: N/A (auto-updates via built-in updater)
# Download page: https://clickup.com/download
#
# Notes:
#   - ClickUp Desktop is free to download and use.
#   - Has a built-in auto-update mechanism (File > ClickUp > Check for updates).
#   - DMG download from official site.
#   - Uninstall: remove app bundle and associated support files.

maclib::productivity::clickup::suite_installer_url() {
  printf '%s\n' 'https://clickup.com/download'
}

maclib::productivity::clickup::latest_version() {
  # No public version API for ClickUp Desktop.
  # The app auto-updates via its built-in updater.
  # No version checking available without the app running.
  printf '%s\n' 'latest'
  return 0
}

maclib::productivity::clickup::is_installed() {
  [[ -d '/Applications/ClickUp.app' ]] || [[ -d "$HOME/Applications/ClickUp.app" ]]
}

maclib::productivity::clickup::installed_path() {
  if [[ -d '/Applications/ClickUp.app' ]]; then
    printf '%s\n' '/Applications/ClickUp.app'
    return 0
  elif [[ -d "$HOME/Applications/ClickUp.app" ]]; then
    printf '%s\n' "$HOME/Applications/ClickUp.app"
    return 0
  fi
  return 1
}

maclib::clickup::install() {
  # ClickUp DMG download from vendor website.
  # The download page (https://clickup.com/download) provides a direct DMG download.
  # Requires root for /Applications install.
  local url tmp mp app
  url="https://clickup.com/download"
  tmp="$(mktemp -d -t "clickup.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download DMG from vendor page
  if ! curl -fsL "$url" -o "$tmp/clickup.html" 2>/dev/null; then
    maclib::core::log::error "clickup::install: failed to fetch download page"
    return 1
  fi

  # Extract DMG URL from page
  local dmg_url
  dmg_url=$(grep -oE 'https://[^"]+\.dmg' "$tmp/clickup.html" | head -1)
  if [[ -z "$dmg_url" ]]; then
    # Fallback: known direct download URL pattern
    dmg_url="https://download.clickup.com/ClickUp.dmg"
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "clickup::install: failed to download DMG"
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

maclib::productivity::clickup::update() {
  # ClickUp Desktop has a built-in auto-update mechanism.
  # Re-run install() to install the latest version.
  maclib::productivity::clickup::install "$@"
}

maclib::productivity::clickup::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/ClickUp.app'
  rm -rf "$HOME/Library/Application Support/ClickUp"
  rm -rf "$HOME/Library/Preferences/com.clickup.clickup.plist"
  rm -rf "$HOME/Library/Caches/com.clickup.clickup"
  rm -rf "$HOME/Library/Saved Application State/com.clickup.clickup.savedState"
  maclib::core::log::info "clickup::uninstall: removed app bundle and support files"
  return 0
}
