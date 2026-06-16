#!/usr/bin/env bash
# Unit tests for helldoctor's pure functions. Renders the template, sources it
# in a subshell (the sourcing guard keeps main() from running), asserts output.
set -uo pipefail
cd "$(dirname "$0")/../.."

rendered="$(mktemp)"
trap 'rm -f "$rendered"' EXIT
chezmoi execute-template < dot_config/scripts/executable_helldoctor.tmpl > "$rendered"

fail=0
check() { # check <description> <expected> <actual>
    if [[ "$2" == "$3" ]]; then
        echo "ok   - $1"
    else
        echo "FAIL - $1: expected '$2' got '$3'"; fail=1
    fi
}

# Run an expression against the sourced script in an isolated subshell.
call() { ( source "$rendered"; "$@" ); }

check "format_size 0"          "0B"      "$(call format_size 0)"
check "format_size 1024"       "1.0KiB"  "$(call format_size 1024)"
check "format_size 1572864"    "1.5MiB"  "$(call format_size 1572864)"
check "format_size non-numeric" "n/a"    "$(call format_size abc)"
check "disk_status above min"  "ok"      "$(call disk_status 42 10)"
check "disk_status at min"     "ok"      "$(call disk_status 10 10)"
check "disk_status below min"  "warn"    "$(call disk_status 5 10)"
check "mark ok"                "✓"       "$(call mark ok)"
check "mark warn"              "⚠"       "$(call mark warn)"

exit "$fail"
