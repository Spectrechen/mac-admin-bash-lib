#!/usr/bin/env bats

setup() {
  # shellcheck source=lib/core/log.sh
  source "${BATS_TEST_DIRNAME}/../lib/core/log.sh"
}

@test "log level filters debug when set to info" {
  run bash -c 'source lib/core/log.sh; maclib::log::set_level info; maclib::log::debug "x"'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "warn goes to stderr" {
  run bash -c 'source lib/core/log.sh; maclib::log::set_level debug; maclib::log::warn "hello" 2>&1 1>/dev/null'
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN] hello"* ]]
}
