#!/usr/bin/env bash
# firefox.sh - Mozilla Firefox (package installer) helpers
#
# Vendor research (see docs/firefox-vendor-notes.md):
#   For managed deployment Mozilla ships a signed .pkg from the Mozilla CDN:
#     https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx
#   The current build is read from Mozilla's product-details JSON.
#   Firefox ships no built-in updater on macOS, so updates are applied by
#   re-deploying the latest package.
#   Apple Developer Team ID: 43AQ936H96 ; package ID: org.mozilla.firefox.
#   Source: Installomator `firefoxpkg` label + product-details.mozilla.org.

# Print the Firefox package installer URL.
maclib::firefox::url() {
  printf '%s\n' 'https://download.mozilla.org/?product=firefox-pkg-latest-ssl&os=osx'
}

# Print the current stable Firefox build version (e.g. 141.0).
# Reads the version from Mozilla's product-details JSON.
maclib::firefox::latest_version() {
  local json version
  json="$(curl -fs 'https://product-details.mozilla.org/1.0/firefox_versions.json' 2>/dev/null)"
  [[ -n "$json" ]] || return 1
  version="$(printf '%s' "$json" | sed -nE 's/.*"LATEST_FIREFOX_VERSION":"([^"]+)".*/\1/p')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Firefox app bundle is installed.
maclib::firefox::is_installed() {
  [[ -d "/Applications/Firefox.app" ]] || [[ -d "$HOME/Applications/Firefox.app" ]]
}

# Print the path to the Firefox app bundle if present.
maclib::firefox::installed_path() {
  if [[ -d "/Applications/Firefox.app" ]]; then
    printf '%s\n' "/Applications/Firefox.app"
  elif [[ -d "$HOME/Applications/Firefox.app" ]]; then
    printf '%s\n' "$HOME/Applications/Firefox.app"
  fi
}

# Download the Firefox package installer and install it (requires root).
maclib::firefox::install() {
  local url tmp
  url="$(maclib::firefox::url)"
  tmp="$(mktemp -t "firefox_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "firefox::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Firefox has no built-in updater on macOS; updates are applied by re-installing
# the latest package (see install()). Documented as no separate update path.
