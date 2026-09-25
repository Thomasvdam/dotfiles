# Shared by personal Bash/Zsh and the opt-in remote Bash session.
alias vi='vim'
alias l='ls -lhF'
alias la='ls -lhaF'
alias ll='ls -lhaF'
alias gs='git status'
alias gf='git fetch --prune --tags'
alias glog='git log --all --decorate --oneline --graph'
alias gco='git checkout -b'
alias grc='git rebase --continue'
alias gap='git add -p'
alias gpf='git push -f'
alias gpo='git push origin HEAD -u'
alias gcma='git commit --amend'
alias gcmf='git commit --fixup'
alias week='date +%V'

# Only add the .., ..., .... aliases if zoxide is not installed.
if ! command -v zoxide >/dev/null 2>&1; then
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
fi