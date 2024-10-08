# Reload config file
alias reload!='. ~/.zshrc'

# zoxide
######################
alias ..="z .."
alias ...="z ../.."
alias ....="z ../../.."

# vim
######################
alias vi=vim

# bat
######################

# Replace cat with bat
alias cat=bat

# exa
######################

# List all files colorized in long format
alias l="eza -lhF"

# List all files colorized in long format, including dot files
alias la="eza -lhaF"
alias ll="la"

# ls
######################

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:"

# Git
######################

alias gs="git status"
alias gf="git fetch --prune --tags"
alias glog="git glog"
alias gco="git checkout -b"
alias grc="git rebase --continue"
alias gap="git add -p"
alias gpf="git push -f"
alias gpo="git push origin HEAD -u"

# rg
######################

rg() {
    if [ -t 1 ]; then
        command rg -p "$@" | less -RFX
    else
        command rg "$@"
    fi
}

# Hidden files
######################

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Useful Shortcuts
######################

# Get week number
alias week="date +%V"

# Recursively delete .DS_Store files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Update brew and installed casks
alias update="brew update && brew upgrade && brew cleanup"

