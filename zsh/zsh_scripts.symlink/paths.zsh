# Add homebrew to path
export PATH="/opt/homebrew/bin:$PATH"

# Forego the automatic Volta setup
export PATH="$VOLTA_HOME/bin:$PATH"

# Add go bin to path
export PATH="$GOPATH/bin:$PATH"

# Add rust tooling to path
. "$HOME/.cargo/env"

