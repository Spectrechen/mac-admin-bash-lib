#!/usr/bin/env bash
# log.sh - simple logging helpers

# Default log level (info)
# Levels: debug=10, info=20, warn=30, error=40
__MACLIB_LOG_LEVEL="${__MACLIB_LOG_LEVEL:-20}"

maclib::core::log::set_level() {
  local level="${1:-}"
  case "$level" in
    debug) __MACLIB_LOG_LEVEL=10 ;;
    info) __MACLIB_LOG_LEVEL=20 ;;
    warn | warning) __MACLIB_LOG_LEVEL=30 ;;
    error) __MACLIB_LOG_LEVEL=40 ;;
    *)
      printf 'maclib::core::log::set_level: unknown level: %s
' "$level" >&2
      return 2
      ;;
  esac
}

maclib::core::log::is_tty() {
  [[ -t 1 ]]
}

__maclib::core::log::_ts() {
  # ISO-like timestamp
  date '+%Y-%m-%dT%H:%M:%S%z'
}

__maclib::core::log::_emit() {
  local level_name="$1" level_num="$2" stream="$3"
  shift 3

  ((__MACLIB_LOG_LEVEL <= level_num)) || return 0

  local ts
  ts="$(__maclib::core::log::_ts)"
  if [[ "$stream" == "stderr" ]]; then
    printf '%s [%s] %s
' "$ts" "$level_name" "$*" >&2
  else
    printf '%s [%s] %s
' "$ts" "$level_name" "$*"
  fi
}

maclib::core::log::debug() { __maclib::core::log::_emit "DEBUG" 10 "stdout" "$@"; }
maclib::core::log::info() { __maclib::core::log::_emit "INFO" 20 "stdout" "$@"; }
maclib::core::log::warn() { __maclib::core::log::_emit "WARN" 30 "stderr" "$@"; }
maclib::core::log::error() { __maclib::core::log::_emit "ERROR" 40 "stderr" "$@"; }
