#!/usr/bin/env bash
# appsanywhere.sh - AppsAnywhere Client (macOS) helpers
#
# Vendor research:
#   AppsAnywhere is a software delivery platform (Citrix). The macOS client
#   is distributed via GitHub Releases and the AppsAnywhere docs portal.
#   Source: https://docs.appsanywhere.com/appsanywhere/3.2/appsanywhere-client-macos
#   - Latest version is extracted from the docs page (pattern: AppsAnywhereClient(macOS)-VersionX.Y.Z(CurrentVersion))
#   - Download URL pattern:
#       https://files.appsanywhere.com/clients/appsanywhere/mac/<version>/apps-anywhere-setup-InstitutionId-<version>.pkg
#     Note: InstitutionId is institution-specific; for generic use the latest
#     release asset from GitHub may be used instead.
#   - Package ID: com.appsanywhere.client (inferred from app bundle)
#   - Team ID: 9ZNX23CMVD
#   - App location: /Applications/AppsAnywhere/AppsAnywhere.app
#   - Update tool: /Applications/AppsAnywhere/AppsAnywhere\ Updater.app
#   - Uninstall: remove app bundle and associated support files.

# Print the AppsAnywhere docs page URL where the latest version is listed.
maclib::apps::appsanywhere::suite_installer_url() {
  printf '%s\n' 'https://docs.appsanywhere.com/appsanywhere/3.2/appsanywhere-client-macos'
}

# Print the latest version by scraping the AppsAnywhere docs page.
maclib::apps::appsanywhere::latest_version() {
  local url ver
  url="$(maclib::apps::appsanywhere::suite_installer_url)"
  ver=$(curl -fsSL "$url" 2>/dev/null | \
    sed -nE 's/.*id="AppsAnywhereClient\(macOS\)-Version([0-9]+\.[0-9]+\.[0-9]+)\(CurrentVersion\)".*/\1/p' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  # Fallback: try GitHub Releases
  ver=$(curl -fsSL 'https://api.github.com/repos/AppsAnywhere/client-macos/releases/latest' 2>/dev/null | \
    grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/' | head -1)
  if [[ -n "$ver" ]]; then
    printf '%s\n' "$ver"
    return 0
  fi
  printf '%s\n' '0'
  return 1
}

# Return 0 if AppsAnywhere client is installed.
maclib::apps::appsanywhere::is_installed() {
  [[ -d '/Applications/AppsAnywhere/AppsAnywhere.app' ]]
  return $?
}

# Print the installed app path if present.
maclib::apps::appsanywhere::installed_path() {
  if [[ -d '/Applications/AppsAnywhere/AppsAnywhere.app' ]]; then
    printf '%s\n' '/Applications/AppsAnywhere/AppsAnywhere.app'
    return 0
  fi
  return 1
}

# Download and install the AppsAnywhere client.
# Requires root (installer writes to /Applications).
# Note: The download URL contains InstitutionId which is institution-specific.
# For generic deployment, use the latest GitHub release asset.
maclib::apps::appsanywhere::install() {
  local url ver tmp pkg_path
  ver="$(maclib::apps::appsanywhere::latest_version)"
  if [[ "$ver" == "0" ]] || [[ -z "$ver" ]]; then
    maclib::core::log::error "appsanywhere::install: could not determine latest version"
    return 1
  fi

  tmp="$(mktemp -d)" || return 1
  trap 'rm -rf "$tmp"' RETURN

  # Try the institution-specific URL first
  url="https://files.appsanywhere.com/clients/appsanywhere/mac/${ver}/apps-anywhere-setup-InstitutionId-${ver}.pkg"
  pkg_path="$tmp/appsanywhere.pkg"

  if ! curl -fsL "$url" -o "$pkg_path" 2>/dev/null; then
    # Fallback: try GitHub release
    url="https://github.com/AppsAnywhere/client-macos/releases/latest/download/appsanywhere.pkg"
    if ! curl -fsL "$url" -o "$pkg_path" 2>/dev/null; then
      maclib::core::log::error "appsanywhere::install: failed to download installer"
      return 1
    fi
  fi

  /usr/sbin/installer -pkg "$pkg_path" -target / 2>/dev/null
  local rc=$?
  rm -f "$pkg_path"
  return "$rc"
}

# Update: same as install (re-installs latest).
maclib::apps::appsanywhere::update() {
  maclib::apps::appsanywhere::install "$@"
}

# Uninstall: remove app bundle and support files.
maclib::apps::appsanywhere::uninstall() {
  rm -rf '/Applications/AppsAnywhere'
  rm -rf "$HOME/Library/Application Support/AppsAnywhere"
  rm -rf '/Library/Application Support/AppsAnywhere'
  rm -f '/Library/LaunchDaemons/com.appsanywhere.*.plist'
  rm -f "$HOME/Library/LaunchAgents/com.appsanywhere.*.plist"
}
