#!/usr/bin/env bash
# shellcheck disable=all
# etrecheck.sh - EtreCheckPro (Installomator label) helpers
#
# Vendor source: Installomator label etrecheck from
#   github.com/Installomator/Installomator (Installomator.sh).
# Installer type: "zip".
#

maclib::security::etrecheck::suite_installer_url() {
  # TODO: Add actual download URL for EtreCheckPro
  printf '%s\\n' 'https://example.com/etrecheck/installer'
}

maclib::security::etrecheck::latest_version() {
  # TODO: Add version detection for EtreCheckPro
  return 1
}

maclib::security::etrecheck::is_installed() {
  [[ -d "/Applications/Etrecheckpro.app" ]] || [[ -d "$HOME/Applications/Etrecheckpro.app" ]]
}

maclib::security::etrecheck::installed_path() {
  if [[ -d "/Applications/Etrecheckpro.app" ]]; then
    printf '%s\\n' "/Applications/Etrecheckpro.app"
  elif [[ -d "$HOME/Applications/Etrecheckpro.app" ]]; then
    printf '%s\\n' "$HOME/Applications/Etrecheckpro.app"
  fi
}

maclib::etrecheck::install() {
  local url tmp
  url="$(maclib::etrecheck::suite_installer_url)"
  tmp="$(mktemp -d -t "etrecheck.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.zip" 2>/dev/null; then
    maclib::core::log::error "etrecheck::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  unzip -oq "$tmp/i.zip" -d "$tmp/extracted" 2>/dev/null
  local rc=0
  local app
  app="$(find "$tmp/extracted" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  return "$rc"
}


maclib::security::etrecheck::update() {
  # No vendor update path documented for "EtreCheckPro".
  maclib::core::log::error "etrecheck::update: no update path"
  return 127
}

maclib::security::etrecheck::uninstall() {
  # No clean uninstall for "EtreCheckPro" (documented constraint).
  maclib::core::log::error "etrecheck::uninstall: no clean uninstall"
  return 1
}
