#!/usr/bin/env bash
# shellcheck disable=all
# airtable.sh - Airtable (disk image) helpers
#
# Vendor source: Installomator label `airtable` (github.com/Installomator/Installomator, Installomator.sh).
#   Airtable ships a signed .dmg from a static URL:
#     https://static.airtable.com/download/AirtableInstaller.dmg
#   Apple Developer Team ID: E22RZMX62E.
#   Installer type: dmg.
#   No vendor-provided version endpoint exists; the dmg URL carries no build
#   number, so latest_version() cannot derive a build and returns non-zero
#   (documented constraint).

# Print the Airtable installer disk-image URL (static).
maclib::communication::airtable::suite_installer_url() {
  printf '%s\n' 'https://static.airtable.com/download/AirtableInstaller.dmg'
}

# Airtable has no vendor version endpoint (the dmg URL carries no build number).
# Returns non-zero; documented as no update path.
maclib::communication::airtable::latest_version() {
  maclib::core::log::warn "airtable::latest_version: no vendor version source"
  return 1
}

# Return 0 if the Airtable app bundle is installed.
maclib::communication::airtable::is_installed() {
  [[ -d "/Applications/Airtable.app" ]] || [[ -d "$HOME/Applications/Airtable.app" ]]
}

# Print the path to the Airtable app bundle if present.
maclib::communication::airtable::installed_path() {
  if [[ -d "/Applications/Airtable.app" ]]; then
    printf '%s\n' "/Applications/Airtable.app"
  elif [[ -d "$HOME/Applications/Airtable.app" ]]; then
    printf '%s\n' "$HOME/Applications/Airtable.app"
  else
    return 1
  fi
}

# Download the Airtable disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::communication::airtable::install() {
  local url dmg mount
  url="$(maclib::communication::airtable::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "airtable_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/airtable_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::core::log::error "airtable::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::core::log::error "airtable::install: failed to mount disk image"
    return 1
  fi
  local app
  app="$(find "$mount" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    cp -R "$app" "/Applications/" "$@"
    local rc=$?
    hdiutil detach "$mount" >/dev/null 2>&1
    return "$rc"
  fi
  hdiutil detach "$mount" >/dev/null 2>&1
  maclib::core::log::error "airtable::install: no .app found in disk image"
  return 1
}

# Airtable has no vendor version endpoint; updates are applied by re-installing
# the latest disk image (see install()). Documented as no separate update path.
maclib::communication::airtable::update() {
  maclib::communication::airtable::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::airtable::uninstall() {
  maclib::core::log::warn "airtable::uninstall: no clean uninstall"
  return 1
}
