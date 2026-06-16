#!/usr/bin/env bash
# Render the helldoctor template and shellcheck the result.
set -euo pipefail
cd "$(dirname "$0")/../.."
src="dot_config/scripts/executable_helldoctor.tmpl"
rendered="$(mktemp)"
trap 'rm -f "$rendered"' EXIT
chezmoi execute-template < "$src" > "$rendered"
shellcheck "$rendered"
echo "shellcheck: clean"
