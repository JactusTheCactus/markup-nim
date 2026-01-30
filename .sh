#!/usr/bin/env bash
set -uo pipefail
flag() {
	for f in "$@"
		do [[ -e ".flags/$f" ]] || return 1
	done
}
shopt -s expand_aliases
alias nim="\$HOME/.nimble/bin/nim"
if ! command -v nim > /dev/null; then
	install=https://nim-lang.org/install.html
	echo "Error: command <nim> not found"
	echo "Install <nim> at <$install>"
	exit 1
fi
rm -rf htmldocs
while read -r i
	do nim md2html "$i"
done < <(find . -name "*.md")
nim compile nim/main.nim
find . -empty -delete
