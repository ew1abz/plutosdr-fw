#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT_DIR"

# Initialize only the firmware repository's direct dependencies. In particular,
# do not recurse into u-boot: its tree contains a stale nested mbedTLS gitlink.
git -c submodule.recurse=false submodule update --init --checkout \
    br2-external buildroot hdl linux u-boot

for required_path in br2-external buildroot hdl linux u-boot; do
    if test ! -f "$required_path/Makefile"; then
        printf '%s\n' "error: missing source tree: $required_path" >&2
        exit 1
    fi
done

printf '%s\n' "Firmware source trees are ready."
