#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/maclib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/maclib.sh"

maclib::log::set_level info
maclib::log::info "macOS? $(maclib::os::is_macos && echo yes || echo no)"
maclib::log::info "Arch: $(maclib::os::arch)"

if maclib::os::is_macos; then
  maclib::log::info "Version: $(maclib::os::version)"
  maclib::log::info "Major.Minor: $(maclib::os::major_minor)"
fi

maclib::log::info "Slugified: $(maclib::util::slugify 'Hello, World! 2026')"
maclib::log::info "Trimmed: [$(maclib::util::trim '   spaced out   ')]"
maclib::log::info "1536 bytes -> $(maclib::util::human_size 1536)"
