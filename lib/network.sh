#!/usr/bin/env bash
# network.sh - macOS network configuration helpers

# Print the primary (highest priority) network service name.
maclib::network::primary_service() {
  local out
  out="$(networksetup -listNetworkServices 2>/dev/null)" || return 1
  # First non-header line is the primary service.
  out="$(printf '%s\n' "$out" | awk 'NR==2 {print; exit}')"
  printf '%s\n' "$out"
}

# Print the primary IP address of the primary network service.
maclib::network::primary_ip() {
  local service
  service="$(maclib::network::primary_service)" || return 1
  networksetup -getipaddress "$service" 2>/dev/null | awk 'NR==2 {print $2}'
}

# Print the current machine hostname (short form).
maclib::network::hostname() {
  hostname
}

# Print the current machine's fully-qualified hostname.
maclib::network::fqdn() {
  hostname -f
}

# Set the machine hostname (requires root).
maclib::network::set_hostname() {
  local name="${1:-}"
  [[ -n "$name" ]] || {
    maclib::log::error "set_hostname: no hostname given"
    return 2
  }
  scutil --set HostName "$name" "$@"
  scutil --set LocalHostName "$name" "$@"
}
