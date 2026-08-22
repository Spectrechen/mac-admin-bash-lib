#!/usr/bin/env bash
# figma.sh - Figma (zip archive) helpers
#
# Vendor research (see docs/figma-vendor-notes.md):
#   Figma ships signed .zip archives from https://desktop.figma.com. The arm64
#   and x86_64 builds are on separate URLs. The current build is read from the
#   RELEASE.json manifest.
#   Apple Developer Team ID: T8RA8NE3B7.
#   Source: Installomator `figma` label.

# Print the Figma zip archive URL (arch-aware).
maclib::figma::url() {
  local url
  if [[ "$(arch)" == "arm64" ]]; then
    url='https://desktop.figma.com/mac-arm/Figma.zip'
  else
    url='https://desktop.figma.com/mac/Figma.zip'
  fi
  printf '%s\n' "$url"
}

# Print the current Figma build version.
# Reads the version from the RELEASE.json manifest.
maclib::figma::latest_version() {
  local json version
  json="$(curl -fs 'https://desktop.figma.com/mac/RELEASE.json' 2>/dev/null)"
  [[ -n "$json" ]] || return 1
  version="$(printf '%s' "$json" | sed -nE 's/.*"version":"([^"]+)".*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Figma app bundle is installed.
maclib::figma::is_installed() {
  [[ -d "/Applications/Figma.app" ]] || [[ -d "$HOME/Applications/Figma.app" ]]
}

# Print the path to the Figma app bundle if present.
maclib::figma::installed_path() {
  if [[ -d "/Applications/Figma.app" ]]; then
    printf '%s\n' "/Applications/Figma.app"
  elif [[ -d "$HOME/Applications/Figma.app" ]]; then
    printf '%s\n' "$HOME/Applications/Figma.app"
  fi
}

# Download the Figma zip archive and extract the app bundle to /Applications
# (requires root).
maclib::figma::install() {
  local url zip extract
  url="$(maclib::figma::url)"
  zip="$(mktemp -t "figma_install.XXXXXX.zip")" || return 1
  extract="$(mktemp -d /tmp/figma_extract.XXXXXX)" || {
    rm -f "$zip"
    return 1
  }
  trap 'rm -f "$zip"; rm -rf "$extract"' RETURN
  if ! curl -fsL "$url" -o "$zip" 2>/dev/null; then
    maclib::log::error "figma::install: failed to download archive"
    return 1
  fi
  if ! unzip -o "$zip" -d "$extract" >/dev/null 2>&1; then
    maclib::log::error "figma::install: failed to extract archive"
    return 1
  fi
  local app
  app="$(find "$extract" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    return "$rc"
  fi
  maclib::log::error "figma::install: no .app found in archive"
  return 1
}

# Figma updates are applied by re-installing the latest archive (see
# install()). Documented as no separate update path.
