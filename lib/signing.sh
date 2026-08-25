#!/usr/bin/env bash
# signing.sh - macOS codesign / notarization helpers

# Code-sign an app/binary/d framework (requires a Developer ID identity).
maclib::signing::codesign() {
  local target="${1:-}"
  [[ -n "$target" ]] || {
    maclib::log::error "codesign: no target given"
    return 2
  }
  /usr/bin/codesign --sign "$@" "$target"
}

# Verify the code signature of an app/binary.
maclib::signing::verify() {
  local target="${1:-}"
  [[ -n "$target" ]] || {
    maclib::log::error "verify: no target given"
    return 2
  }
  /usr/bin/codesign --verify --deep --strict "$target" "$@"
}

# Print the developer identity (Team ID) embedded in a code signature.
maclib::signing::identity() {
  local target="${1:-}"
  [[ -n "$target" ]] || {
    maclib::log::error "identity: no target given"
    return 2
  }
  /usr/bin/codesign --display-identity "$target" "$@"
}

# Submit a bundle to Apple's Notary Service (requires Xcode + credentials).
maclib::signing::notarize() {
  local bundle="${1:-}"
  [[ -n "$bundle" ]] || {
    maclib::log::error "notarize: no bundle given"
    return 2
  }
  xcr notarytool submit "$bundle" "$@"
}

# Pre-check a bundle for notarization issues without submitting.
maclib::signing::notarize_preflight() {
  local bundle="${1:-}"
  [[ -n "$bundle" ]] || {
    maclib::log::error "notarize_preflight: no bundle given"
    return 2
  }
  xcr notarytool preflight "$bundle" "$@"
}

# Staple the notarization ticket onto a bundle (requires a submission ID).
maclib::signing::notarize_staple() {
  local bundle="${1:-}"
  [[ -n "$bundle" ]] || {
    maclib::log::error "notarize_staple: no bundle given"
    return 2
  }
  xcr notarytool staple "$bundle" "$@"
}
