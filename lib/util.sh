#!/usr/bin/env bash
# util.sh - generic (cross-platform) Bash utility helpers
#
# Portable to bash 3.2 (macOS default): avoids ${var,,}, [[ =~ ]] and other
# bash 4+ constructs so the library works with the system shell.

# Trim leading and trailing whitespace from a string.
# Prints the trimmed result on stdout (no trailing newline added).
maclib::util::trim() {
	local s="${1:-}"
	# Strip leading whitespace.
	s="${s#"${s%%[![:space:]]*}"}"
	# Strip trailing whitespace.
	s="${s%"${s##*[![:space:]]}"}"
	printf '%s' "$s"
}

# Turn an arbitrary string into a URL/file-name-safe slug.
# Lowercased, runs of non-alphanumeric characters collapsed to a single
# hyphen, leading/trailing hyphens removed.
maclib::util::slugify() {
	local s="${1:-}"
	# Lowercase (portable to bash 3.2).
	s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]')"
	# Replace any run of non [a-z0-9] characters with a single hyphen.
	s="$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g')"
	# Strip leading/trailing hyphens.
	s="${s#-}"
	s="${s%-}"
	printf '%s' "$s"
}

# Format a byte count as a human-readable string (base 1024, SI suffixes).
# Usage: maclib::util::human_size 1536  -> "1.5 KB"
maclib::util::human_size() {
	local bytes="${1:-}"
	# Reject empty or strings containing any non-digit character.
	case "$bytes" in
	'' | *[!0-9]*)
		maclib::log::error "human_size: not a non-negative integer: ${1:-<none>}"
		return 2
		;;
	esac

	local suffixes=(B KB MB GB TB PB EB)
	local e=0 raw="$bytes"
	# Find the exponent via integer division (keeps the original bytes for
	# the fractional formatting below).
	while [[ "$e" -lt $((${#suffixes[@]} - 1)) && "$raw" -ge 1024 ]]; do
		raw=$((raw / 1024))
		e=$((e + 1))
	done

	if [[ "$e" -eq 0 ]]; then
		printf '%s %s\n' "$bytes" "${suffixes[0]}"
	else
		awk -v b="$bytes" -v e="$e" 'BEGIN {
			split("B KB MB GB TB PB EB", suf, " ");
			printf "%.1f %s\n", b / (1024 ^ e), suf[e + 1]
		}'
	fi
}

# Retry a command up to N times with a fixed delay between attempts.
# Usage: maclib::util::retry <max_attempts> <delay_seconds> [cmd...]
# Returns the exit status of the final attempt. Prints nothing on success.
maclib::util::retry() {
	local max="${1:-}"
	local delay="${2:-}"
	shift 2 || true
	case "$max" in
	'' | *[!0-9]*)
		[[ "$max" -ge 1 ]] || {
			maclib::log::error "retry: max_attempts must be a positive integer"
			return 2
		}
		;;
	esac
	case "$delay" in
	'' | *[!0-9.]* | *.*.**)
		maclib::log::error "retry: delay must be a non-negative number"
		return 2
		;;
	esac
	[[ $# -gt 0 ]] || {
		maclib::log::error "retry: no command given"
		return 2
	}

	local attempt=1 out
	while true; do
		if out="$("$@" 2>&1)"; then
			printf '%s\n' "$out"
			return 0
		fi
		if [[ "$attempt" -ge "$max" ]]; then
			printf '%s\n' "$out" >&2
			return 1
		fi
		maclib::log::warn "retry: attempt $attempt/$max failed; retrying in ${delay}s"
		sleep "$delay"
		attempt=$((attempt + 1))
	done
}

# Interactive yes/no confirmation. Reads from stdin.
# Usage: maclib::util::confirm "Proceed with install?"
# Returns 0 on yes (or empty/EOF treated as no), 1 otherwise.
maclib::util::confirm() {
	local prompt="${1:-Proceed?}"
	local answer
	printf '%s [y/N] ' "$prompt"
	if ! IFS= read -r answer; then
		# EOF (e.g. piped input exhausted) -> treat as "no".
		return 1
	fi
	# Lowercase and trim (portable to bash 3.2).
	answer="$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')"
	answer="$(maclib::util::trim "$answer")"
	case "$answer" in
	y | yes) return 0 ;;
	*) return 1 ;;
	esac
}

# Create a directory (and parents) if it does not already exist.
# Returns 0 if the directory exists afterward, non-zero on failure.
maclib::util::ensure_dir() {
	local path="${1:-}"
	[[ -n "$path" ]] || {
		maclib::log::error "ensure_dir: no path given"
		return 2
	}
	if [[ -d "$path" ]]; then
		return 0
	fi
	if mkdir -p "$path" >/dev/null 2>&1; then
		maclib::log::debug "ensure_dir: created $path"
		return 0
	fi
	maclib::log::error "ensure_dir: could not create $path"
	return 1
}
