#!/usr/bin/env bash
# shellcheck disable=all
# awscli2.sh - "AWSCLI" (Installomator label) helpers
#
# Vendor source: Installomator label awscli2 from
#   github.com/Installomator/Installomator (Installomator.sh).
# Apple Developer Team ID: "94KV3E626L".
# Package ID: "com.amazon.aws.cli2".
# Installer type: "pkg".
#

maclib::awscli2::suite_installer_url() {
  https://awscli.amazonaws.com/AWSCLIV2.pkg
}

maclib::awscli2::latest_version() {
  curl -fs "https://raw.githubusercontent.com/aws/aws-cli/v2/CHANGELOG.rst" | grep -i "CHANGELOG" -a4 | grep "[0-9.]"
}

maclib::awscli2::is_installed() {
  pkgutil --pkg-info ""com.amazon.aws.cli2"" >/dev/null 2>&1
}

maclib::awscli2::installed_path() {
  local p
  p="$(pkgutil --pkg-info ""com.amazon.aws.cli2"" 2>/dev/null | sed -nE "s/^path: //p")"
  [[ -n "$p" ]] && printf "%s\n" "$p"
  return 1
}

maclib::awscli2::install() {
  local url tmp
  url="$(maclib::awscli2::suite_installer_url)"
  tmp="$(mktemp -d -t "awscli2.XXXXXX")" || return 1
  trap 'rm -rf "$tmp"' RETURN
  if ! curl -fsL "$url" -o "$tmp/i.dmg" 2>/dev/null; then
    maclib::log::error "awscli2::install: download failed"
    rm -rf "$tmp"
    return 1
  fi
  local mp="$tmp/mount"
  mkdir -p "$mp"
  hdiutil attach "$tmp/i.dmg" -mountpoint "$mp" -nobrowse >/dev/null 2>&1
  local rc=0
  local app
  app="$(find "$mp" -name "*.app" | head -n1)"
  [[ -n "$app" ]] && cp -R "$app" "/Applications/" || rc=1
  hdiutil detach "$mp" >/dev/null 2>&1
  return "$rc"
}

maclib::awscli2::update() {
  # No vendor update path documented for "AWSCLI".
  maclib::log::error "awscli2::update: no update path"
  return 127
}

maclib::awscli2::uninstall() {
  # No clean uninstall for "AWSCLI"; removing package receipt ""com.amazon.aws.cli2"".
  pkgutil --forget ""com.amazon.aws.cli2""
  return $?
}
