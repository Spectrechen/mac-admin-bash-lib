#!/usr/bin/env bash
# shellcheck disable=all
# aircall.sh - Aircall Workspace (electron app, zip) helpers
#
# Vendor source: Installomator label aircall (github.com/Installomator/Installomator, Installomator.sh).
#   Aircall is an Electron app updated through its own endpoint:
#     https://electron.aircall.io/update/osx/1.0.0?channel=stable
#   The endpoint returns JSON whose "url" field is the zip installer and whose
#   "name" field is the current version.
#   Apple Developer Team ID: 3ML357Q795.
#   Installer type: zip (electron auto-updater artifact).

# Print the Aircall Workspace zip installer URL (extracted from the
# https://electron.aircall.io/update/osx/1.0.0?channel=stable JSON payload).
maclib::aircall::suite_installer_url() {
  local payload url
  payload="$(curl -fsL 'https://electron.aircall.io/update/osx/1.0.0?channel=stable' 2>/dev/null)"
  [[ -n "$payload" ]] || return 1
  url="$(printf '%s' "$payload" | sed -n 's/.*"url":"\([^"]*\)".*/\1/p' | head -n1)"
  [[ -n "$url" ]] || return 1
  printf '%s\n' "$url"
}

# Print the current Aircall Workspace build version (JSON "name" field).
maclib::aircall::latest_version() {
  local payload version
  payload="$(curl -fsL 'https://electron.aircall.io/update/osx/1.0.0?channel=stable' 2>/dev/null)"
  [[ -n "$payload" ]] || return 1
  version="$(printf '%s' "$payload" | sed -n 's/.*"name":"\([^"]*\)".*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Aircall Workspace app bundle is installed.
maclib::aircall::is_installed() {
  [[ -d "/Applications/Aircall.app" ]] || [[ -d "$HOME/Applications/Aircall.app" ]]
}

# Print the path to the Aircall Workspace app bundle if present.
maclib::aircall::installed_path() {
  if [[ -d "/Applications/Aircall.app" ]]; then
    printf '%s\n' "/Applications/Aircall.app"
  elif [[ -d "$HOME/Applications/Aircall.app" ]]; then
    printf '%s\n' "$HOME/Applications/Aircall.app"
  else
    return 1
  fi
}

# Download the Aircall Workspace zip installer, unzip it and copy the app
# bundle to /Applications (requires root).
maclib::aircall::install() {
  local url tmp dir
  url="$(maclib::aircall::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  tmp="$(mktemp -d "/tmp/aircall_install.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/archive.zip" 2>/dev/null; then
    maclib::log::error "aircall::install: failed to download installer"
    return 1
  fi
  if ! unzip -oq "$tmp/archive.zip" -d "$tmp/extracted" 2>/dev/null; then
    maclib::log::error "aircall::install: failed to unzip installer"
    return 1
  fi
  local app
  app="$(find "$tmp/extracted" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    /usr/bin cp -R "$app" "/Applications/" "$@"
    local rc=$?
    return "$rc"
  fi
  maclib::log::error "aircall::install: no .app found in installer"
  return 1
}

# Aircall updates are applied by re-installing the latest zip (see install()).
# Documented as no separate update path.
maclib::aircall::update() {
  maclib::aircall::install "$@"
}

# No clean uninstall (documented constraint).
maclib::aircall::uninstall() {
  maclib::log::warn "aircall::uninstall: no clean uninstall"
  return 1
}
