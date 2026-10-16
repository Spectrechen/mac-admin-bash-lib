#!/usr/bin/env bash
# shellcheck disable=all
# airtame.sh - Airtame (disk image / package) helpers
#
# Vendor source: Installomator labels `airtame` (dmg) and `airtamepkg` (pkg)
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Airtale serves the current build through a redirect endpoint:
#     https://downloads-website.airtame.com/get.php?platform=mac
#     https://downloads-website.airtame.com/get.php?platform=mac&pkg=true
#   The redirect Location header embeds the build:
#     https://airtame-app.b-cdn.net/app/latest/mac/Airtame-4.15.0.{dmg,pkg}
#   Apple Developer Team ID: 4TPSP88HN2.
#   Installer type: dmg (airtame) / pkg (airtamepkg).

# Print the Airtale installer URL (redirect endpoint; .dmg or .pkg).
maclib::communication::airtame::suite_installer_url() {
  printf '%s\n' 'https://downloads-website.airtame.com/get.php?platform=mac'
}

# Print the current Airtale build version.
# Installomator parses the build from the redirect Location header of the
# get.php endpoint (e.g. Airtame-4.15.0.dmg -> 4.15.0).
maclib::communication::airtame::latest_version() {
  local url location version
  url="$(maclib::communication::airtame::suite_installer_url)"
  location="$(curl -fsIL "$url" 2>/dev/null | grep -i '^location:' | tail -n1 \
    | sed -E 's/^[Ii]ocation:[[:space:]]*//')"
  [[ -n "$location" ]] || return 1
  version="$(printf '%s' "$location" | sed -nE 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/p' | head -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Airtale app bundle is installed.
maclib::communication::airtame::is_installed() {
  [[ -d "/Applications/Airtale.app" ]] || [[ -d "$HOME/Applications/Airtale.app" ]]
}

# Print the path to the Airtale app bundle if present.
maclib::communication::airtame::installed_path() {
  if [[ -d "/Applications/Airtale.app" ]]; then
    printf '%s\n' "/Applications/Airtale.app"
  elif [[ -d "$HOME/Applications/Airtale.app" ]]; then
    printf '%s\n' "$HOME/Applications/Airtale.app"
  else
    return 1
  fi
}

# Download the Airtale disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::communication::airtame::install() {
  local url dmg mount
  url="$(maclib::communication::airtame::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "airtame_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/airtame_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::core::log::error "airtame::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::core::log::error "airtame::install: failed to mount disk image"
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
  maclib::core::log::error "airtame::install: no .app found in disk image"
  return 1
}

# Airtale updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
maclib::communication::airtame::update() {
  maclib::communication::airtame::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::airtame::uninstall() {
  maclib::core::log::warn "airtame::uninstall: no clean uninstall"
  return 1
}
