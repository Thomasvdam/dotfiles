# Shared by personal Bash/Zsh and the opt-in remote Bash session.
mkdird() {
    if [ "$#" -ne 1 ]; then
        printf 'Usage: mkdird DIRECTORY\n' >&2
        return 2
    fi
    mkdir -p "$1" && cd "$1"
}
