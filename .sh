#!/usr/bin/env bash
set -uo pipefail
export nim="$HOME/.nimble/bin/nim"
if ! command -v "$nim" > /dev/null; then
	printf '%s\n%s\n' \
		"Error: command <nim> not found" \
		"Install <nim> at <https://nim-lang.org/install.html>"
	exit 1
fi
clear
if make "$@"; then
	# ./bin/main
	clear #-x
	./bin/test
fi
