#!/usr/bin/env bash
# shellcheck disable=all
# amazonchime.sh - Amazon Chime (disk image) helpers
#
# Vendor source: Installomator label amazonchime (github.com/Installomator/Installomator, Installomator.sh).
#   Amazon Chime ships a signed .dmg from https://clients.chime.aws/mac/latest.
#   The current build is parsed from the redirect Location header of that URL.
#   Apple Developer Team ID: 94KV3E626L.

# Print the Amazon Chime installer disk-image URL.
maclib::amazonchime::suite_installer_url() {
  printf '%s\n' 'https://clients.chime.aws/mac/latest'
}

# Print the current Amazon Chime build version.
# Installomator parses the version from the redirect Location header of the
# installer URL (the dotted number before the .dmg).
maclib::amazonchime::latest_version() {
  local url location version
  url="$(maclib::amazonchime::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | sed -E 's/.*\/[a-zA-Z.\-]*-([0-9.]*)\..*/\1/' | grep -oE '[0-9]+\.[0-9.]*' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Amazon Chime app bundle is installed.
maclib::amazonchime::is_installed() {
  [[ -d "/Applications/Amazon Chime.app" ]] || [[ -d "$HOME/Applications/Amazon Chime.app" ]]
}

# Print the path to the Amazon Chime app bundle if present.
maclib::amazonchime::installed_path() {
  if [[ -d "/Applications/Amazon Chime.app" ]]; then
    printf '%s\n' "/Applications/Amazon Chime.app"
  elif [[ -d "$HOME/Applications/Amazon Chime.app" ]]; then
    printf '%s\n' "$HOME/Applications/Amazon Chime.app"
  else
    return 1
  fi
}

# Download the Amazon Chime disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::amazonchime::install() {
  local url dmg mount
  url="$(maclib::amazonchime::suite_installer_url)"
  dmg="$(mktemp -t "amazonchime_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/amazonchime_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "amazonchime::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "amazonchime::install: failed to mount disk image"
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
  maclib::log::error "amazonchime::install: no .app found in disk image"
  return 1
}

# Amazon Chime updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::amazonchime::update() {
  maclib::amazonchime::install "$@"
}

# No clean uninstall (documented constraint).
maclib::amazonchime::uninstall() {
  maclib::log::warn "amazonchime::uninstall: no clean uninstall"
  return 1
}
