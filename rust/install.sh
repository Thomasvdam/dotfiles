#!/bin/sh
#
# Rust
#
# This installs the Rustup which helps managing the Rust toolchain.

# Check for rustup
if test ! $(which rustup)
then
  echo "  Installing Rustup for you."

  bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)"
fi

exit 0
