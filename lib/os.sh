#!/usr/bin/env bash
# os.sh - macOS detection helpers

maclib::os::is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

maclib::os::version() {
  # Outputs e.g. 14.4.1
  if ! maclib::os::is_macos; then
    printf 'maclib::os::version: not macOS
' >&2
    return 1
  fi
  /usr/bin/sw_vers -productVersion
}

maclib::os::major_minor() {
  local v
  v="$(maclib::os::version)"
  # Keep first two components
  local major minor rest
  IFS='.' read -r major minor rest <<<"$v"
  printf '%s.%s
' "$major" "$minor"
}

maclib::os::arch() {
  uname -m
}
