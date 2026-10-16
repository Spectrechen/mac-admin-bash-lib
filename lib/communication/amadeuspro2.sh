#!/usr/bin/env bash
# shellcheck disable=all
# amadeuspro2.sh - Amadeus Pro (zip archive) helpers
#
# Vendor source: Installomator label `amadeuspro2`
#   (github.com/Installomator/Installomator, Installomator.sh).
#   Amadeus Pro ships a signed zip from AWS S3:
#     https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip
#   The current build is read from the vendor page:
#     https://www.hairersoft.com/pro.html
#   Apple Developer Team ID: FWDH9W45C2.
#   Installer type: zip.

# Print the Amadeus Pro zip installer URL (AWS S3).
maclib::communication::amadeuspro2::suite_installer_url() {
  printf '%s\n' 'https://s3.amazonaws.com/AmadeusPro2/AmadeusPro.zip'
}

# Print the current Amadeus Pro build version.
# Installomator parses the build from the vendor page pro.html
# (the "version N.N.N" string).
maclib::communication::amadeuspro2::latest_version() {
  local html version
  html="$(curl -fs 'https://www.hairersoft.com/pro.html' 2>/dev/null)"
  [[ -n "$html" ]] || return 1
  version="$(printf '%s' "$html" \
    | grep -ioE "version[: ]+[0-9]+\.[0-9]+(\.[0-9]+)?" | head -n1 \
    | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?")"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the Amadeus Pro app bundle is installed.
maclib::communication::amadeuspro2::is_installed() {
  [[ -d "/Applications/Amadeus Pro.app" ]] || [[ -d "$HOME/Applications/Amadeus Pro.app" ]]
}

# Print the path to the Amadeus Pro app bundle if present.
maclib::communication::amadeuspro2::installed_path() {
  if [[ -d "/Applications/Amadeus Pro.app" ]]; then
    printf '%s\n' "/Applications/Amadeus Pro.app"
  elif [[ -d "$HOME/Applications/Amadeus Pro.app" ]]; then
    printf '%s\n' "$HOME/Applications/Amadeus Pro.app"
  else
    return 1
  fi
}

# Download the Amadeus Pro zip installer, unzip it and copy the app bundle to
# /Applications (requires root).
maclib::communication::amadeuspro2::install() {
  local url tmp dir
  url="$(maclib::communication::amadeuspro2::suite_installer_url)"
  [[ -n "$url" ]] || return 1
  tmp="$(mktemp -d "/tmp/amadeuspro2_install.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/archive.zip" 2>/dev/null; then
    maclib::core::log::error "amadeuspro2::install: failed to download installer"
    return 1
  fi
  if ! unzip -oq "$tmp/archive.zip" -d "$tmp/extracted" 2>/dev/null; then
    maclib::core::log::error "amadeuspro2::install: failed to unzip installer"
    return 1
  fi
  local app
  app="$(find "$tmp/extracted" -maxdepth 2 -type d -name '*.app' | head -n1)"
  if [[ -n "$app" ]]; then
    cp -R "$app" "/Applications/" "$@"
    local rc=$?
    return "$rc"
  fi
  maclib::core::log::error "amadeuspro2::install: no .app found in installer"
  return 1
}

# Amadeus Pro updates are applied by re-installing the latest zip (see
# install()). Documented as no separate update path.
maclib::communication::amadeuspro2::update() {
  maclib::communication::amadeuspro2::install "$@"
}

# No clean uninstall (documented constraint).
maclib::communication::amadeuspro2::uninstall() {
  maclib::core::log::warn "amadeuspro2::uninstall: no clean uninstall"
  return 1
}
