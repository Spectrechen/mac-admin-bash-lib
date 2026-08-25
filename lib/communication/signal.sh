#!/usr/bin/env bash
# signal.sh - Signal (disk image) helpers
#
# Vendor research (see docs/signal-vendor-notes.md):
#   Signal ships signed .dmg installers from updates.signal.org, resolved via a
#   latest-mac.yml manifest. The current build is read from that manifest.
#   Apple Developer Team ID: U68MSDN6DR.
#   Source: Installomator `signal` label.

# Print the Signal installer disk-image URL.
# Signal's latest-mac.yml lists relative file names (e.g.
#   signal-desktop-mac-universal-8.24.1.dmg); Installomator prepends the
#   https://updates.signal.org/desktop/ base.
maclib::signal::url() {
  local url file
  file="$(curl -fs 'https://updates.signal.org/desktop/latest-mac.yml' 2>/dev/null \
    | awk '/url/ && /dmg/ {print $3}' | grep -i universal | head -n1)"
  [[ -n "$file" ]] || return 1
  printf '%s\n' "https://updates.signal.org/desktop/${file}"
}

# Print the current Signal build version.
# Reads the version from the latest-mac.yml manifest.
maclib::signal::latest_version() {
  local version
  version="$(curl -fs 'https://updates.signal.org/desktop/latest-mac.yml' 2>/dev/null | grep -E '^version:' | awk '{print $2}' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Signal app bundle is installed.
maclib::signal::is_installed() {
  [[ -d "/Applications/Signal.app" ]] || [[ -d "$HOME/Applications/Signal.app" ]]
}

# Print the path to the Signal app bundle if present.
maclib::signal::installed_path() {
  if [[ -d "/Applications/Signal.app" ]]; then
    printf '%s\n' "/Applications/Signal.app"
  elif [[ -d "$HOME/Applications/Signal.app" ]]; then
    printf '%s\n' "$HOME/Applications/Signal.app"
  fi
}

# Download the Signal disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::signal::install() {
  local url dmg mount
  url="$(maclib::signal::url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "signal_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/signal_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "signal::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "signal::install: failed to mount disk image"
    return 1
  fi
  local app
  app="$(find "$mount" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$mount" >/dev/null 2>&1
    return "$rc"
  fi
  hdiutil detach "$mount" >/dev/null 2>&1
  maclib::log::error "signal::install: no .app found in disk image"
  return 1
}

# Signal updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
