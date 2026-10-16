#!/usr/bin/env bash
# shellcheck disable=all
# webexteams.sh - Webex (disk image) helpers
#
# Vendor source: Installomator label webexteams
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Webex ships a signed .dmg from binaries.webex.com, with separate Apple
#   Silicon and Intel build directories. The current build is parsed from the
#   Webex "What's New" help page.
#   Apple Developer Team ID: DE8Y96K9QP.

# Print the Webex installer disk-image URL (chosen by CPU architecture).
maclib::communication::webexteams::suite_installer_url() {
  if [[ "$(uname -m)" == "arm64" ]]; then
    printf '%s\n' 'https://binaries.webex.com/webex-macos-apple-silicon/Webex.dmg'
  else
    printf '%s\n' 'https://binaries.webex.com/webex-macos-intel/Webex.dmg'
  fi
}

# Print the current Webex build version.
# Installomator parses the version from the Webex "What's New" help page.
maclib::communication::webexteams::latest_version() {
  local version
  version="$(curl -fsL 'https://help.webex.com/en-us/article/8dmbcr/Webex-App-%7C-What%27s-New' 2>/dev/null \
    | tr '"' '\n' | grep 'Mac—' | head -n1 | sed 's/[^0-9.]//g')"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Webex app bundle is installed.
maclib::communication::webexteams::is_installed() {
  [[ -d "/Applications/Webex.app" ]] || [[ -d "$HOME/Applications/Webex.app" ]]
}

# Print the path to the Webex app bundle if present.
maclib::communication::webexteams::installed_path() {
  if [[ -d "/Applications/Webex.app" ]]; then
    printf '%s\n' "/Applications/Webex.app"
  elif [[ -d "$HOME/Applications/Webex.app" ]]; then
    printf '%s\n' "$HOME/Applications/Webex.app"
  else
    return 1
  fi
}

# Download the Webex disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::communication::webexteams::install() {
  local url dmg mount
  url="$(maclib::communication::webexteams::suite_installer_url)"
  dmg="$(mktemp -t "webexteams_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/webexteams_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::core::log::error "webexteams::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::core::log::error "webexteams::install: failed to mount disk image"
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
  maclib::core::log::error "webexteams::install: no .app found in disk image"
  return 1
}

# Webex updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::communication::webexteams::update() {
  maclib::communication::webexteams::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::webexteams::uninstall() {
  maclib::core::log::warn "webexteams::uninstall: no clean uninstall"
  return 1
}
