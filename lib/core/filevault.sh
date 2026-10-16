#!/usr/bin/env bash
# filevault.sh - macOS File Vault full-disk-encryption helpers

# Print the current File Vault status string (e.g. "On", "Off", "Pending").
maclib::core::filevault::fdestatus() {
  # FV1 legacy: use the fstool helper if present.
  if command -v fstool >/dev/null 2>&1; then
    fstool --list 2>/dev/null | grep -i 'FileVault' | sed 's/^ *//'
  else
    # Fallback: parse diskutil output for the encrypted volume state.
    diskutil list 2>/dev/null | grep -i 'FileVault' | sed 's/^ *//'
  fi
}

# Enable File Vault full-disk encryption (requires root + a local account).
maclib::core::filevault::enable() {
  diskutil apfs enableFDE "$@"
}

# Disable File Vault full-disk encryption (requires root).
maclib::core::filevault::disable() {
  diskutil apfs disableFDE "$@"
}

# Return 0 if File Vault is currently enabled.
maclib::core::filevault::is_enabled() {
  local status
  status="$(maclib::core::filevault::fdestatus)" || return $?
  [[ "$status" =~ [Ee]nabled ]]
}
