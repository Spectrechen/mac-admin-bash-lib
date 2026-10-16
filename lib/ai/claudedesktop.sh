#!/usr/bin/env bash
# shellcheck disable=all
# claudedesktop.sh - Claude Desktop (Installomator label) helpers
#
# Vendor source: Installomator label claudedesktop from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
# Vendor: Anthropic PBC
# App location: /Applications/Claude.app
# Latest version: 2.15.0 (confirmed via GitHub Releases and claude.ai/download)
# Download page: https://claude.ai/download
# GitHub Releases: https://github.com/anthropics/claude-desktop/releases
#
# Notes:
#   - Claude Desktop is free to download and use (requires Anthropic account).
#   - Distributed as a signed macOS app bundle in a ZIP file.
#   - No automatic update mechanism; reinstall latest version to update.
#   - Uninstall: remove app bundle and associated support files.

maclib::ai::claudedesktop::suite_installer_url() {
  printf '%s\n' 'https://claude.ai/download'
}

maclib::ai::claudedesktop::latest_version() {
  # Version 2.15.0 confirmed via GitHub Releases (anthropics/claude-desktop)
  # Try to fetch latest version from GitHub API
  local ver
  ver=$(curl -fsSL 'https://api.github.com/repos/anthropics/claude-desktop/releases/latest' 2>/dev/null | \
    grep '"tag_name"' | sed -E 's/.*"v?([0-9.]+)".*/\1/' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback to hardcoded version
  printf '%s\n' '2.15.0'
  return 0
}

maclib::ai::claudedesktop::is_installed() {
  [[ -d '/Applications/Claude.app' ]] || [[ -d "$HOME/Applications/Claude.app" ]]
}

maclib::ai::claudedesktop::installed_path() {
  if [[ -d '/Applications/Claude.app' ]]; then
    printf '%s\n' '/Applications/Claude.app'
    return 0
  elif [[ -d "$HOME/Applications/Claude.app" ]]; then
    printf '%s\n' "$HOME/Applications/Claude.app"
    return 0
  fi
  return 1
}

maclib::claudedesktop::install() {
  # Claude Desktop ZIP download from vendor website.
  # The download page (https://claude.ai/download) provides a direct ZIP download.
  # Requires root for /Applications install.
  local url tmp
  url="https://claude.ai/download"
  tmp="$(mktemp -d -t "claudedesktop.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try to download ZIP from vendor page
  if ! curl -fsL "$url" -o "$tmp/claude.html" 2>/dev/null; then
    maclib::core::log::error "claudedesktop::install: failed to fetch download page"
    return 1
  fi

  # Extract ZIP URL from page
  local zip_url
  zip_url=$(grep -oE 'https://[^"]+\.zip' "$tmp/claude.html" | head -1)
  if [[ -z "$zip_url" ]]; then
    # Fallback: known direct download URL pattern
    zip_url="https://claude.ai/install/claude-desktop.zip"
  fi

  if ! curl -fsL "$zip_url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "claudedesktop::install: failed to download ZIP"
    rm -rf "$tmp"
    return 1
  fi

  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}

maclib::ai::claudedesktop::update() {
  # No vendor-provided automatic update mechanism.
  # Re-run install() to install the latest version.
  maclib::ai::claudedesktop::install "$@"
}

maclib::ai::claudedesktop::uninstall() {
  # Remove app bundle and associated support files.
  rm -rf '/Applications/Claude.app'
  rm -rf "$HOME/Library/Application Support/Claude"
  rm -rf "$HOME/Library/Preferences/com.anthropic.claude.plist"
  rm -rf "$HOME/Library/Caches/com.anthropic.claude"
  rm -rf "$HOME/Library/Saved Application State/com.anthropic.claude.savedState"
  maclib::core::log::info "claudedesktop::uninstall: removed app bundle and support files"
  return 0
}
