#!/bin/sh
set -eu

game_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P) || exit 1

if [ ! -x "$game_dir/build/dungeon" ]; then
    printf '%s\n' 'Dungeon executable is missing from the installed game tree.' >&2
    exit 1
fi

if [ -t 1 ] && [ -n "${TERM:-}" ] &&
   command -v clear >/dev/null 2>&1; then
    clear
fi

cd "$game_dir/build"
# exec ./dungeon
exec sh ./dungeon
