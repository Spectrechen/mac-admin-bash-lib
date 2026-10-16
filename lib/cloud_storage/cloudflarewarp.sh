#!/usr/bin/env bash
# shellcheck disable=all
# cloudflarewarp.sh - Cloudflare_WARP (Installomator label) helpers
#
# Vendor source: Installomator label cloudflarewarp from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "pkg".
#

maclib::cloud_storage::cloudflarewarp::suite_installer_url() {
  # TODO: Add actual download URL for Cloudflare_WARP
  printf '%s\\n' 'https://example.com/cloudflarewarp/installer'
}

maclib::cloud_storage::cloudflarewarp::latest_version() {
  # TODO: Add version detection for Cloudflare_WARP
  return 1
}

maclib::cloud_storage::cloudflarewarp::is_installed() {
  [[ -d "/Applications/Cloudflare_Warp.app" ]] || [[ -d "$HOME/Applications/Cloudflare_Warp.app" ]]
}

maclib::cloud_storage::cloudflarewarp::installed_path() {
  if [[ -d "/Applications/Cloudflare_Warp.app" ]]; then
    printf '%s\\n' "/Applications/Cloudflare_Warp.app"
  elif [[ -d "$HOME/Applications/Cloudflare_Warp.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Cloudflare_Warp.app"
  fi
}

maclib::cloudflarewarp::install() {
  local url tmp
  url="$(maclib::cloudflarewarp::suite_installer_url)"
  tmp="$(mktemp -t "cloudflarewarp_install.XXXXXX.pkg")" || return 1
  trap 'rm -f "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then
    maclib::core::log::error "cloudflarewarp::install: failed to download package installer"
    rm -f "$tmp"
    return 1
  fi
  /usr/sbin/installer -pkg "$tmp" -target "$@"
  local rc=$?
  rm -f "$tmp"
  return "$rc"
}


maclib::cloud_storage::cloudflarewarp::update() {
  # No vendor update path documented for "Cloudflare_WARP".
  maclib::core::log::error "cloudflarewarp::update: no update path"
  return 127
}

maclib::cloud_storage::cloudflarewarp::uninstall() {
  # No clean uninstall for "Cloudflare_WARP" (documented constraint).
  maclib::core::log::error "cloudflarewarp::uninstall: no clean uninstall"
  return 1
}
