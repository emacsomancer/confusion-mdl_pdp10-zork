#!/bin/sh
set -eu

header=confusion_patched/macros.hpp

if ! grep -qF '#include <stdint.h>' "$header"; then
    temporary="${header}.tmp"
    {
        printf '%s\n' '#include <stdint.h>'
        cat "$header"
    } > "$temporary"
    mv "$temporary" "$header"
fi
