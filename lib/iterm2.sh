#!/usr/bin/env bash
# iterm2.sh - iTerm2 (zip archive) helpers
#
# Vendor research (see docs/iterm2-vendor-notes.md):
#   iTerm2 ships a signed .zip from https://iterm2.com/downloads/stable/latest.
#   The current build is parsed from the redirect Location header.
#   Apple Developer Team ID: H7V7XYVQ7D.
#   Source: Installomator `iterm2` label.

# Print the iTerm2 zip archive URL.
maclib::iterm2::url() {
  printf '%s\n' 'https://iterm2.com/downloads/stable/latest'
}

# Print the current iTerm2 build version.
# Installomator parses the version from the redirect Location header of the
# zip URL.
maclib::iterm2::latest_version() {
  local url location version
  url="$(maclib::iterm2::url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  # Location ends in "iTerm2-<version>.zip".
  if [[ "$location" =~ iTerm2-([0-9.]*)\.zip ]]; then
    version="${BASH_REMATCH[1]}"
  fi
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the iTerm2 app bundle is installed.
maclib::iterm2::is_installed() {
  [[ -d "/Applications/iTerm.app" ]] || [[ -d "$HOME/Applications/iTerm.app" ]]
}

# Print the path to the iTerm2 app bundle if present.
maclib::iterm2::installed_path() {
  if [[ -d "/Applications/iTerm.app" ]]; then
    printf '%s\n' "/Applications/iTerm.app"
  elif [[ -d "$HOME/Applications/iTerm.app" ]]; then
    printf '%s\n' "$HOME/Applications/iTerm.app"
  fi
}

# Download the iTerm2 zip archive and extract the app bundle to /Applications
# (requires root).
maclib::iterm2::install() {
  local url zip extract
  url="$(maclib::iterm2::url)"
  zip="$(mktemp -t "iterm2_install.XXXXXX.zip")" || return 1
  extract="$(mktemp -d /tmp/iterm2_extract.XXXXXX)" || {
    rm -f "$zip"
    return 1
  }
  trap 'rm -f "$zip"; rm -rf "$extract"' RETURN
  if ! curl -fsL "$url" -o "$zip" 2>/dev/null; then
    maclib::log::error "iterm2::install: failed to download archive"
    return 1
  fi
  if ! unzip -o "$zip" -d "$extract" >/dev/null 2>&1; then
    maclib::log::error "iterm2::install: failed to extract archive"
    return 1
  fi
  local app
  app="$(find "$extract" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    return "$rc"
  fi
  maclib::log::error "iterm2::install: no .app found in archive"
  return 1
}

# iTerm2 updates are applied by re-installing the latest archive (see
# install()). Documented as no separate update path.
