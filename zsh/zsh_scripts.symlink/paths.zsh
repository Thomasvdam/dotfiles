# Add homebrew to path
export PATH="/opt/homebrew/bin:$PATH"

# Forego the automatic Volta setup
export PATH="$VOLTA_HOME/bin:$PATH"

# Add rust tooling to path
. "$HOME/.cargo/env"

