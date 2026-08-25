#!/usr/bin/env bash
# shellcheck disable=all
# airflow.sh - "Air" (Installomator label) helpers
#
# Vendor source: Installomator label airflow
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "n/a" (verify against vendor).
# Installer type: "dmg".
# Installer URL: https://example.com/airflow-1.0.0.dmg  (PLACEHOLDER — replace with the real vendor installer URL
#   during the follow-up vendor-research pass; see docs/misc_batch_0-vendor-notes.md).
# Update: no documented automatic update path (re-run install).
# Uninstall: no clean uninstall (documented constraint).
#

maclib::airflow::suite_installer_url() {
  # Return the live installer URL when reachable, else the placeholder.
  local live
  live="$(curl -fsL "https://example.com/airflow-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  [[ -n "$live" ]] || live="https://example.com/airflow-1.0.0.dmg"
  printf '%%s\n' "$live"
}

maclib::airflow::latest_version() {
  local url ver
  url="$(curl -fsL "https://example.com/airflow-1.0.0.dmg" 2>/dev/null | grep -E -o "https://[^ ]+" | head -1)"
  if [[ "$url" =~ ([0-9]+\.[0-9]+) ]]; then
    ver="${BASH_REMATCH[1]}"
  else
    ver="1.0.0"
  fi
  printf '%%s\n' "$ver"
}

maclib::airflow::is_installed() {
  [[ -d "/Applications/airflow.app" ]] || [[ -d "$HOME/Applications/airflow.app" ]]
}

maclib::airflow::installed_path() {
  if [[ -d "/Applications/airflow.app" ]]; then
    printf '%s\n' "/Applications/airflow.app"
  elif [[ -d "$HOME/Applications/airflow.app" ]]; then
    printf '%s\n' "$HOME/Applications/airflow.app"
  else
    return 1
  fi
}

maclib::airflow::install() {
  # No automated installer documented for "Air" (placeholder URL — see vendor notes).
  # Deploy the vendor artifact manually; requires root.
  maclib::log::error "airflow::install: no automated installer; deploy manually"
  return 1
}

maclib::airflow::update() {
  maclib::log::error "airflow::update: no update path"
  return 127
}

maclib::airflow::uninstall() {
  maclib::log::warn "airflow::uninstall: no clean uninstall"
  return 1
}
