#!/usr/bin/env bash
# shellcheck disable=all
# cisdemdocumentreader.sh - Cisdem Document Reader (Installomator label) helpers
#
# Vendor source: Installomator label cisdemdocumentreader from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "dmg".
# Vendor: Cisdem Inc.
# App location: /Applications/Cisdem-Documentreader.app
# Latest version: 5.5.1 (confirmed via Homebrew cask and cisdem.com)
# Download page: https://www.cisdem.com/document-reader.html
#
# Notes:
#   - Cisdem Document Reader is a commercial product (free to download, paid for full features).
#   - Available via Homebrew: brew install --cask cisdem-document-reader
#   - No automatic update mechanism; reinstall latest version to update.

maclib::apps::c::cisdemdocumentreader::suite_installer_url() {
  printf '%s\n' 'https://www.cisdem.com/document-reader.html'
}

maclib::apps::c::cisdemdocumentreader::latest_version() {
  # Version 5.5.1 confirmed via Homebrew cask formulae.brew.sh/cask/cisdem-document-reader
  # No public API for version checking; hardcode latest known.
  printf '%s\n' '5.5.1'
  return 0
}

maclib::apps::c::cisdemdocumentreader::is_installed() {
  [[ -d '/Applications/Cisdem-Documentreader.app' ]] || [[ -d "$HOME/Applications/Cisdem-Documentreader.app" ]]
}

maclib::apps::c::cisdemdocumentreader::installed_path() {
  if [[ -d '/Applications/Cisdem-Documentreader.app' ]]; then
    printf '%s\n' '/Applications/Cisdem-Documentreader.app'
    return 0
  elif [[ -d "$HOME/Applications/Cisdem-Documentreader.app" ]]; then
    printf '%s\n' "$HOME/Applications/Cisdem-Documentreader.app"
    return 0
  fi
  return 1
}

maclib::cisdemdocumentreader::install() {
  # Cisdem Document Reader DMG download from vendor website.
  # The download page (https://www.cisdem.com/document-reader.html) provides a direct DMG download.
  # Requires root for /Applications install.
  local url tmp mp app
  url="https://www.cisdem.com/document-reader.html"
  tmp="$(mktemp -d -t "cisdemdocumentreader.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download DMG from vendor page
  if ! curl -fsL "$url" -o "$tmp/cisdem.html" 2>/dev/null; then
    maclib::core::log::error "cisdemdocumentreader::install: failed to fetch download page"
    return 1
  fi

  # Extract DMG URL from page
  local dmg_url
  dmg_url=$(grep -oE 'https://[^"]+\.dmg' "$tmp/cisdem.html" | head -1)
  if [[ -z "$dmg_url" ]]; then
    # Fallback: try the direct download URL pattern
    dmg_url="https://www.cisdem.com/app/dl/CisdemDocumentReader.dmg"
  fi

  if ! curl -fsL "$dmg_url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::core::log::error "cisdemdocumentreader::install: failed to download DMG"
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

maclib::apps::c::cisdemdocumentreader::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::apps::c::cisdemdocumentreader::install "$@"
}

maclib::apps::c::cisdemdocumentreader::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Cisdem-Documentreader.app'
  rm -rf "$HOME/Library/Application Support/Cisdem/Documentreader"
  rm -rf "$HOME/Library/Preferences/com.cisdem.Documentreader.plist"
  rm -rf "$HOME/Library/Caches/com.cisdem.Documentreader"
  maclib::core::log::info "cisdemdocumentreader::uninstall: removed app bundle and support files"
  return 0
}
