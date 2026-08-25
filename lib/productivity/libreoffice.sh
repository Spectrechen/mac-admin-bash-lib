#!/usr/bin/env bash
# libreoffice.sh - LibreOffice (disk image) helpers
#
# Vendor research (see docs/libreoffice-vendor-notes.md):
#   LibreOffice ships signed .dmg installers from the document foundation CDN,
#   with arm64/x86_64 variants. The current build is read from the download
#   directory listing.
#   Apple Developer Team ID: 7P5S3ZLCN7.
#   Source: Installomator `libreoffice` label.

# Print the LibreOffice installer disk-image URL (arch-aware).
maclib::libreoffice::url() {
  local version arch url
  version="$(maclib::libreoffice::latest_version)"
  [[ -n "$version" ]] || return 1
  if [[ "$(arch)" == "arm64" ]]; then
    arch="aarch64"
  else
    arch="x86_64"
  fi
  url="https://download.documentfoundation.org/libreoffice/stable/${version}/mac/${arch}/LibreOffice_${version}_MacOS_${arch}.dmg"
  printf '%s\n' "$url"
}

# Print the current LibreOffice build version (e.g. 7.6.7).
# Reads the latest stable version from the download directory listing.
maclib::libreoffice::latest_version() {
  local html version
  html="$(curl -fs 'https://download.documentfoundation.org/libreoffice/stable/' 2>/dev/null)"
  [[ -n "$html" ]] || return 1
  version="$(printf '%s' "$html" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -n1)"
  [[ -n "$version" ]] || return 1
  printf '%s\n' "$version"
}

# Return 0 if the LibreOffice app bundle is installed.
maclib::libreoffice::is_installed() {
  [[ -d "/Applications/LibreOffice.app" ]] || [[ -d "$HOME/Applications/LibreOffice.app" ]]
}

# Print the path to the LibreOffice app bundle if present.
maclib::libreoffice::installed_path() {
  if [[ -d "/Applications/LibreOffice.app" ]]; then
    printf '%s\n' "/Applications/LibreOffice.app"
  elif [[ -d "$HOME/Applications/LibreOffice.app" ]]; then
    printf '%s\n' "$HOME/Applications/LibreOffice.app"
  fi
}

# Download the LibreOffice disk image, mount it and copy the app bundle to
# /Applications (requires root).
maclib::libreoffice::install() {
  local url dmg mount
  url="$(maclib::libreoffice::url)"
  [[ -n "$url" ]] || return 1
  dmg="$(mktemp -t "libreoffice_install.XXXXXX.dmg")" || return 1
  mount="$(mktemp -d /tmp/libreoffice_dmg.XXXXXX)" || {
    rm -f "$dmg"
    return 1
  }
  trap 'rm -f "$dmg"; rm -rf "$mount"' RETURN
  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then
    maclib::log::error "libreoffice::install: failed to download disk image"
    return 1
  fi
  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then
    maclib::log::error "libreoffice::install: failed to mount disk image"
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
  maclib::log::error "libreoffice::install: no .app found in disk image"
  return 1
}

# LibreOffice updates are applied by re-installing the latest disk image (see
# install()). Documented as no separate update path.
