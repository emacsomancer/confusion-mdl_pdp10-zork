#!/bin/sh
set -eu

out=${1:?Usage: install.sh OUTPUT EXPECT-PREFIX}
expect_prefix=${2:?Usage: install.sh OUTPUT EXPECT-PREFIX}

bin="$out/bin"
libexec="$out/libexec/confusion-mdl"
share="$out/share/confusion-mdl"
doc="$out/share/doc/confusion-mdl-zork"

mkdir -p "$bin" "$libexec" "$share" "$doc"

# Confusion interpreter.
install -m755 confusion_patched/mdli "$bin/mdli"

# MDL runner.
install -m644 zork-run-scripts/zork-mdli-run \
    "$libexec/zork-mdli-run"

# Dungeon runner.
install -m644 zork-run-scripts/dungeon-3.2b-run \
    "$libexec/dungeon-3.2b-run"

# Dungeon executable, source, documentation, and data.
cp -R dungeon_3_2b "$share/"

# Install the self-locating Dungeon launcher.
install -m644 zork-run-scripts/dungeon.sh \
    "$share/dungeon_3_2b/dungeon.sh"

# Playable MDL game trees.
for version in 771212 780124 791211 810722; do
    mkdir -p "$share/mdlzork_$version"
    cp -R "mdlzork_$version/patched_confusion" \
        "$share/mdlzork_$version/"
done

# Additional reference/source trees. No MDL launchers.
for directory in \
    mdlzork_780402 \
    zork_285 \
    mdlzork_binaries_for_pdp-10_its
do
    cp -R "$directory" "$share/"
done

# Interactive selector and direct version launchers.
install -m755 zork-run-scripts/zork-mdl "$bin/zork-mdl"
install -m644 zork-run-scripts/zork-version "$bin/zork-version"

# for year in 1977 1978 1979 1981; do
#     ln -s zork-version "$bin/zork-$year"
# done

# Interpreter license.
install -m644 confusion_patched/COPYING "$doc/COPYING"
