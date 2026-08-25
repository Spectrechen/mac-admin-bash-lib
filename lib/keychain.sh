#!/usr/bin/env bash
# keychain.sh - macOS security/keychain helpers

# Return 0 if a keychain with the given name exists.
maclib::keychain::exists() {
  local name="${1:-}"
  [[ -n "$name" ]] || {
    maclib::log::error "exists: no keychain name given"
    return 2
  }
  /usr/bin/security find-keychain -d user "$name" >/dev/null 2>&1
}

# Add a generic password to a keychain (requires root for system keychain).
maclib::keychain::add() {
  local service="${1:-}"
  local account="${2:-}"
  local password="${3:-}"
  [[ -n "$service" && -n "$account" && -n "$password" ]] || {
    maclib::log::error "add: service, account and password required"
    return 2
  }
  /usr/bin/security add-generic-password -s "$service" -a "$account" -W "$password" "$@"
}

# Delete a generic password entry from a keychain.
maclib::keychain::delete() {
  local service="${1:-}"
  local account="${2:-}"
  [[ -n "$service" && -n "$account" ]] || {
    maclib::log::error "delete: service and account required"
    return 2
  }
  /usr/bin/security delete-generic-password -s "$service" -a "$account" "$@"
}

# Print whether a generic password entry exists for the given service/account.
maclib::keychain::has_entry() {
  local service="${1:-}"
  local account="${2:-}"
  [[ -n "$service" && -n "$account" ]] || return 2
  /usr/bin/security find-generic-password -s "$service" -a "$account" >/dev/null 2>&1
}
