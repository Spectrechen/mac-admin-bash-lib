#!/usr/bin/env bash
# chrome.sh - Google Chrome (package installer) helpers
#
# Vendor research (see docs/chrome-vendor-notes.md):
#   Chrome for Mac is distributed as an Apple .pkg from Google's CDN. Enterprise
#   deployment uses the signed package installer:
#     https://dl.google.com/chrome/mac/stable/.../googlechrome.pkg
#   The current build is read from the Google Chrome version-history API.
#   Updates are delivered by the Google Software Update agent.
#   Apple Developer Team ID: EQHXZ8M8AV ; package ID: com.google.chrome.
#   Source: Installomator `googlechromepkg` label + Google Chrome version API.

# Print the Google Chrome package installer URL.
maclib::chrome::url() {
  printf '%s\n' 'https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg'
}

# Print the current stable Chrome build version (e.g. 131.0.6778.86).
# Reads the version from the Google Chrome version-history API.
maclib::chrome::latest_version() {
  local json version
  json="$(curl -fsL 'https://versionhistory.googleapis.com/v1/chrome/platforms/mac/channels/stable/versions/all/releases?filter=fraction>0.01,endtime=none&order_by=version%20desc' 2>/dev/null)"
  [[ -n "$json" ]] || return 1
  version="$(printf '%s' "$json" | sed -nE 's/.*"version":"([^"]+)".*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Chrome app bundle is installed.
maclib::chrome::is_installed() {
  [[ -d "/Applications/Google Chrome.app" ]] || [[ -d "$HOME/Applications/Google Chrome.app" ]]
}

# Print the path to the Chrome app bundle if present.
maclib::chrome::installed_path() {
  if [[ -d "/Applications/Google Chrome.app" ]]; then
    printf '%s\n' "/Applications/Google Chrome.app"
  elif [[ -d "$HOME/Applications/Google Chrome.app" ]]; then
    printf '%s\n' "$HOME/Applications/Google Chrome.app"
  fi
}

# Download the Chrome package installer and install it (requires root).
maclib::chrome::install() {
  local url tmp
  url="$(maclib::chrome::url)"
  tmp="$(mktemp -t "chrome_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "chrome::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Update Chrome via the Google Software Update agent when present.
maclib::chrome::update() {
  local tool='/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/GoogleSoftwareUpdateAgent.app/Contents/MacOS/GoogleSoftwareUpdateAgent'
  if [[ -x "$tool" ]]; then
    "$tool" -runMode oneshot -userInitiated YES "$@"
    return $?
  fi
  maclib::log::error "chrome::update: Google Software Update agent not found"
  return 127
}
