#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/maclib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/maclib.sh"

maclib::core::log::set_level info
maclib::core::log::info "macOS? $(maclib::core::os::is_macos && echo yes || echo no)"
maclib::core::log::info "Arch: $(maclib::core::os::arch)"

if maclib::core::os::is_macos; then
  maclib::core::log::info "Version: $(maclib::core::os::version)"
  maclib::core::log::info "Major.Minor: $(maclib::core::os::major_minor)"
fi
