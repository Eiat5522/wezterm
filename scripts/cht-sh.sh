#!/usr/bin/env bash
# shellcheck shell=bash

query="${1:-}"

run_cht_sh() {
	if command -v cht.sh >/dev/null 2>&1; then
		cht.sh --shell=bash --mode=auto "$query"
	elif command -v curl >/dev/null 2>&1; then
		curl -fsSL "https://cht.sh/${query// /+}"
	else
		printf 'Neither cht.sh nor curl is available in this shell.\n' >&2
		return 127
	fi
}

while true; do
	read -r -e -i "$query" -p "cht.sh query> " query || exec bash -li
	if [ -z "$query" ]; then
		printf 'Enter a query, or press Ctrl-D to open an interactive shell.\n'
		continue
	fi

	clear
	printf 'cht.sh: %s\n\n' "$query"
	if run_cht_sh; then
		printf '\n'
		exec bash -li
	fi

	status=$?
	printf '\nNo cht.sh entry found for "%s" (exit %s).\n' "$query" "$status"
	printf $'\033]777;notify;cht.sh;No entry found for %s\033\\' "$query"
done
