alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias update='brew update && brew upgrade && brew cleanup'

server() {
    local port="${1:-8000}"
    (sleep 1 && open "http://localhost:${port}/") &
    python3 -m http.server "$port"
}

curs() {
    cursor "${1:-.}"
}

getip() {
    local ip
    if [ "$#" -eq 0 ]; then
        ip=$(ipconfig getifaddr en0) || return
        printf 'Local ip: '
    elif [ "$1" = '-e' ] || [ "$1" = '--external' ]; then
        ip=$(curl -fsS https://ipecho.net/plain) || return
        printf 'External ip: '
    else
        printf 'Usage: getip [-e | --external]\n' >&2
        return 2
    fi
    printf '%s\n' "$ip"
    printf '%s' "$ip" | pbcopy
}
