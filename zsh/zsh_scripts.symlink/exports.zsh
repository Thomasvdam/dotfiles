# Default editor
export EDITOR="vi"

# Default less settings
export LESS="-FRX"

# Make brew work nicely with nvm
source $(brew --prefix nvm)/nvm.sh

# nvm path
export NVM_DIR=~/.nvm

# Export caskroom path
export HOMEBREW_CASK_OPTS="--caskroom=$(brew --repository)/Caskroom"

