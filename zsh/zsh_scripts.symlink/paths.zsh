# Add casks to path
export PATH=$(brew --repository)/Caskroom:$PATH

# Add cabal binaries to path
export PATH=~/.cabal/bin:$PATH

# Add rust tools to path
export PATH="$HOME/.cargo/bin:$PATH"
