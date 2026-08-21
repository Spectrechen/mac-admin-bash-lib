#!/usr/bin/env bats
# Combined bats tests for the macAdmin Library modules.

setup() {
  source "${BATS_TEST_DIRNAME}/../lib/maclib.sh"
}

# ---------------------------------------------------------------------------
# logging (existing)
# ---------------------------------------------------------------------------

@test "log filters debug when level is info" {
  run bash -c 'source lib/log.sh; maclib::log::set_level info; maclib::log::debug "x"'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "log warn goes to stderr" {
  run bash -c 'source lib/log.sh; maclib::log::set_level debug; maclib::log::warn "hello" 2>&1 1>/dev/null'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN] hello"* ]]
}

# ---------------------------------------------------------------------------
# os module
# ---------------------------------------------------------------------------

@test "os::is_macos returns 0 on macOS" {
  run maclib::os::is_macos
  [ "$status" -eq 0 ]
}

@test "os::version returns a dotted string" {
  run maclib::os::version
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

@test "os::major_minor returns two components" {
  run maclib::os::major_minor
  [ "$status" -eq 0 ]
  [[ "$output" =~ [0-9]+\.[0-9]+ ]]
}

# ---------------------------------------------------------------------------
# user module
# ---------------------------------------------------------------------------

@test "user::is_root returns integer exit code" {
  run maclib::user::is_root
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}

@test "user::current_user returns non-empty name" {
  run maclib::user::current_user
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

@test "user::home_dir returns a path" {
  run maclib::user::home_dir
  [ "$status" -eq 0 ]
  [[ "$output" == */ ]] || [[ "$output" == /* ]]
}

# ---------------------------------------------------------------------------
# system module (SIP state is readable without root)
# ---------------------------------------------------------------------------

@test "system::sip_status returns a state string" {
  run maclib::system::sip_status
  [ "$status" -eq 0 ]
  [[ "$output" == *"enabled" || "$output" == *"disabled" || "$output" == *"unconfigured" ]]
}

# ---------------------------------------------------------------------------
# packages module (list is read-only, no args)
# ---------------------------------------------------------------------------

@test "packages::pkg_list returns exit 0" {
  run maclib::packages::pkg_list
  [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# signing module (verify with no target must return 2)
# ---------------------------------------------------------------------------

@test "signing::verify with no target returns 2" {
  run maclib::signing::verify
  [ "$status" -eq 2 ]
}

@test "signing::codesign with no target returns 2" {
  run maclib::signing::codesign
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# keychain module (has_entry with no args returns 2)
# ---------------------------------------------------------------------------

@test "keychain::has_entry with no args returns 2" {
  run maclib::keychain::has_entry
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# launchd module (is_loaded with no label returns 2)
# ---------------------------------------------------------------------------

@test "launchd::is_loaded with no label returns 2" {
  run maclib::launchd::is_loaded
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# management module (is_managed is readable without root)
# ---------------------------------------------------------------------------

@test "management::isManaged returns exit 0, 1, or 127 (absent tool)" {
  run maclib::management::isManaged
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ] || [ "$status" -eq 127 ]
}

# ---------------------------------------------------------------------------
# network module (hostname is readable without root)
# ---------------------------------------------------------------------------

@test "network::hostname returns non-empty" {
  run maclib::network::hostname
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}

# ---------------------------------------------------------------------------
# app module (is_installed with no name returns 2)
# ---------------------------------------------------------------------------

@test "app::isInstalled with no name returns 2" {
  run maclib::app::is_installed
  [ "$status" -eq 2 ]
}

# ---------------------------------------------------------------------------
# util module (cross-platform helpers)
# ---------------------------------------------------------------------------

@test "util::trim strips surrounding whitespace" {
  run maclib::util::trim "   hello world   "
  [ "$status" -eq 0 ]
  [ "$output" == "hello world" ]
}

@test "util::trim handles empty and whitespace-only input" {
  run maclib::util::trim ""
  [ "$status" -eq 0 ]
  [ -z "$output" ]

  run maclib::util::trim "    "
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "util::slugify lowercases and hyphenates" {
  run maclib::util::slugify "Hello, World! 2026"
  [ "$status" -eq 0 ]
  [ "$output" == "hello-world-2026" ]
}

@test "util::slugify strips leading/trailing separators" {
  run maclib::util::slugify "  --A B--  "
  [ "$status" -eq 0 ]
  [ "$output" == "a-b" ]
}

@test "util::human_size converts bytes to KB/GB" {
  run maclib::util::human_size 1536
  [ "$status" -eq 0 ]
  [ "$output" == "1.5 KB" ]

  run maclib::util::human_size 0
  [ "$status" -eq 0 ]
  [ "$output" == "0 B" ]

  run maclib::util::human_size 1073741824
  [ "$status" -eq 0 ]
  [ "$output" == "1.0 GB" ]
}

@test "util::human_size rejects non-integer input" {
  run maclib::util::human_size "abc"
  [ "$status" -eq 2 ]

  run maclib::util::human_size "-5"
  [ "$status" -eq 2 ]
}

@test "util::ensure_dir creates missing directory" {
  local d
  d="$(mktemp -d)/sub/dir"
  [[ -d "$d" ]] || d="/tmp/maclib_test_$$"
  run maclib::util::ensure_dir "$d"
  [ "$status" -eq 0 ]
  [[ -d "$d" ]]
  rm -rf "$d" 2>/dev/null || true
}

@test "util::ensure_dir accepts existing directory" {
  local d
  d="$(mktemp -d)"
  run maclib::util::ensure_dir "$d"
  [ "$status" -eq 0 ]
  rm -rf "$d" 2>/dev/null || true
}

@test "util::ensure_dir with no path returns 2" {
  run maclib::util::ensure_dir
  [ "$status" -eq 2 ]
}

@test "util::slugify with no input returns empty" {
  run maclib::util::slugify
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
