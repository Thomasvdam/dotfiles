#!/bin/sh
# Explicit package step for an owned Debian/Ubuntu machine.
set -eu
cd "$(dirname "$0")"

if ! command -v apt-get >/dev/null 2>&1; then
    printf 'This package list requires apt-get (Debian/Ubuntu).\n' >&2
    exit 1
fi

packages=$(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' debian-ubuntu.txt)
if [ -z "$packages" ]; then
    exit 0
fi

# Package names are maintained in this repository, one per line.
# shellcheck disable=SC2086
sudo apt-get install $packages
