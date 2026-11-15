#!/bin/sh
set -eu

out=${1:?Usage: install.sh OUTPUT EXPECT-PREFIX}
expect_prefix=${2:?Usage: install.sh OUTPUT EXPECT-PREFIX}

bin="$out/bin"
libexec="$out/libexec/confusion-mdl"
share="$out/share/confusion-mdl"
doc="$out/share/doc/confusion-mdl-zork"

mkdir -p "$bin" "$libexec" "$share" "$doc"

# Expect is used by the 1979 and 1981 Continue paths.
test -x "$expect_prefix/bin/expect"
ln -s "$expect_prefix/bin/expect" "$libexec/expect"

# Confusion MDL interpreter.
install -m755 confusion_patched/mdli "$bin/mdli"

# Dungeon 3.2b executable, source, documentation, and data.
cp -R dungeon_3_2b "$share/"

# Playable MDL game trees.
for version in 771212 780124 791211 810722; do
    mkdir -p "$share/mdlzork_$version"
    cp -R "mdlzork_$version/patched_confusion" \
        "$share/mdlzork_$version/"
done

# Additional reference/source trees.
for directory in \
    mdlzork_780402 \
    zork_285 \
    mdlzork_binaries_for_pdp-10_its
do
    cp -R "$directory" "$share/"
done

# Sole application entry point.
install -m755 zork-run-scripts/zork-mdl "$bin/zork-mdl"

# MDL menu and runtime support.
install -m644 zork-run-scripts/zorkmenu.mud \
    "$share/zorkmenu.mud"

install -m644 zork-run-scripts/zorkrun.mud \
    "$share/zorkrun.mud"

# Expect-based restore support for 1979 and 1981.
install -m644 zork-run-scripts/zork-restore.exp \
    "$libexec/zork-restore.exp"

# Interpreter license.
install -m644 confusion_patched/COPYING "$doc/COPYING"
