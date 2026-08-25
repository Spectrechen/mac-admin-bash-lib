#!/usr/bin/env bash
# launchd.sh - macOS launchd service helpers

# Load (bootstrap) a launchd plist for the current user.
maclib::launchd::load() {
  local plist="${1:-}"
  [[ -n "$plist" ]] || {
    maclib::log::error "load: no plist path given"
    return 2
  }
  launchctl bootstrap "$HOME/Library/LaunchAgents" "$plist" "$@"
}

# Unload (bootout) a launchd plist for the current user.
maclib::launchd::unload() {
  local plist="${1:-}"
  [[ -n "$plist" ]] || {
    maclib::log::error "unload: no plist path given"
    return 2
  }
  launchctl bootout "$HOME/Library/LaunchAgents" "$plist" "$@"
}

# Return 0 if a launchd service (by label) is currently loaded.
maclib::launchd::is_loaded() {
  local label="${1:-}"
  [[ -n "$label" ]] || {
    maclib::log::error "is_loaded: no label given"
    return 2
  }
  launchctl list "$label" >/dev/null 2>&1
}

# Print the launchd state (e.g. "0", "1", "104") for a given label.
maclib::launchd::state() {
  local label="${1:-}"
  [[ -n "$label" ]] || {
    maclib::log::error "state: no label given"
    return 2
  }
  launchctl list "$label" 2>/dev/null | awk 'NR==2 {print $2}'
}

# Reload (unload then load) a launchd plist.
maclib::launchd::reload() {
  local plist="${1:-}"
  [[ -n "$plist" ]] || {
    maclib::log::error "reload: no plist path given"
    return 2
  }
  maclib::launchd::unload "$plist" 2>/dev/null || true
  maclib::launchd::load "$plist" "$@"
}
