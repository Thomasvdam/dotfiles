#!/bin/sh
# Explicit package step for an owned Debian/Ubuntu machine.
set -eu
package_file=${1:-"$HOME/.config/dotfiles/packages/apt.txt"}

if ! command -v apt-get >/dev/null 2>&1; then
    printf 'This package list requires apt-get (Debian/Ubuntu).\n' >&2
    exit 1
fi

if [ ! -f "$package_file" ]; then
    printf 'Package list not found: %s\nRun chezmoi apply first.\n' "$package_file" >&2
    exit 1
fi

packages=$(sed '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$package_file")
if [ -z "$packages" ]; then
    exit 0
fi

# Package names come from chezmoi's rendered list, one per line.
# shellcheck disable=SC2086
sudo apt-get install $packages
