#!/bin/sh
# Explicit, per-user installers for tools managed by their publishers.
set -eu

usage() {
    cat <<'EOF'
Usage: tools/install.sh TOOL [TOOL ...]

Tools: rustup starship bun
Already installed tools are skipped. Keep using their existing install channel for updates.
EOF
}

if [ "$#" -eq 0 ]; then
    usage
    exit 2
fi

# Validate the complete request before installing anything.
for tool in "$@"; do
    case $tool in
        rustup|starship|bun) ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown tool: %s\n' "$tool" >&2
            usage >&2
            exit 2
            ;;
    esac
done

installer_file=
trap 'if [ -n "$installer_file" ]; then rm -f "$installer_file"; fi' 0

download() {
    if ! command -v curl >/dev/null 2>&1; then
        printf 'curl is required to download publisher installers.\n' >&2
        exit 1
    fi
    installer_file=$(mktemp "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")
    curl --proto '=https' --tlsv1.2 -fsSL "$1" -o "$installer_file"
}

clean_download() {
    rm -f "$installer_file"
    installer_file=
}

for tool in "$@"; do
    case $tool in
        rustup)
            if command -v rustup >/dev/null 2>&1 || [ -x "$HOME/.cargo/bin/rustup" ]; then
                printf 'rustup is already installed; skipping.\n'
                continue
            fi
            printf 'Installing rustup from rustup.rs...\n'
            download https://sh.rustup.rs
            sh "$installer_file" -y --no-modify-path
            clean_download
            ;;
        starship)
            if command -v starship >/dev/null 2>&1 || [ -x "$HOME/.local/bin/starship" ]; then
                printf 'starship is already installed; skipping.\n'
                continue
            fi
            mkdir -p "$HOME/.local/bin"
            printf 'Installing starship from starship.rs...\n'
            download https://starship.rs/install.sh
            sh "$installer_file" -y -b "$HOME/.local/bin"
            clean_download
            ;;
        bun)
            if command -v bun >/dev/null 2>&1 || [ -x "$HOME/.bun/bin/bun" ]; then
                printf 'bun is already installed; skipping.\n'
                continue
            fi
            if ! command -v bash >/dev/null 2>&1 || ! command -v unzip >/dev/null 2>&1; then
                printf 'Bun requires bash and unzip. Install them first.\n' >&2
                exit 1
            fi
            printf 'Installing bun from bun.com...\n'
            download https://bun.com/install
            bash "$installer_file"
            clean_download
            ;;
    esac
done
