#!/usr/bin/env bash
# zoom.sh - Zoom (package installer) helpers
#
# Vendor research (see docs/zoom-vendor-notes.md):
#   Zoom ships a signed installer package (ZoomInstallerIT.pkg) from
#   https://zoom.us/client/latest/. The current version is embedded in the
#   redirect Location header of that URL.
#   Apple Developer Team ID: BJ4HAAB9B3 ; package ID: com.zoom.universalclient.
#   Source: Installomator `zoom` label.

# Print the Zoom installer package URL.
maclib::zoom::url() {
  printf '%s\n' 'https://zoom.us/client/latest/ZoomInstallerIT.pkg'
}

# Print the current Zoom build version.
# Installomator parses the version from the redirect Location header of the
# installer URL (cut -d "/" -f5).
maclib::zoom::latest_version() {
  local url location version
  url="$(maclib::zoom::url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ll]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  # Version is the dotted number embedded in the redirect Location.
  version="$(printf '%s' "$location" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)*' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Zoom app bundle is installed.
maclib::zoom::is_installed() {
  [[ -d "/Applications/Zoom.app" ]] || [[ -d "$HOME/Applications/Zoom.app" ]]
}

# Print the path to the Zoom app bundle if present.
maclib::zoom::installed_path() {
  if [[ -d "/Applications/Zoom.app" ]]; then
    printf '%s\n' "/Applications/Zoom.app"
  elif [[ -d "$HOME/Applications/Zoom.app" ]]; then
    printf '%s\n' "$HOME/Applications/Zoom.app"
  fi
}

# Download the Zoom installer package and install it (requires root).
maclib::zoom::install() {
  local url tmp
  url="$(maclib::zoom::url)"
  tmp="$(mktemp -t "zoom_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::log::error "zoom::install: failed to download installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}

# Zoom has a self-updating installer; updates are applied by re-installing the
# latest package (see install()). Documented as no separate update path.
