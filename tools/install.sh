#!/bin/sh
# Explicit, per-user installers for tools managed by their publishers.
set -eu

usage() {
    cat <<'EOF'
Usage: tools/install.sh TOOL [TOOL ...]

Tools: rustup starship bun codex claude zoxide git-delta
       zoxide: Linux only; git-delta: Ubuntu only
Already installed tools are skipped. Keep using their existing install channel for updates.
EOF
}

if [ "$#" -eq 0 ]; then
    usage
    exit 2
fi

# Validate the complete request before installing anything.
is_ubuntu() {
    [ "$(uname -s)" = Linux ] && [ -r /etc/os-release ] &&
        grep -Eq '^ID="?ubuntu"?$' /etc/os-release
}

for tool in "$@"; do
    case $tool in
        rustup|starship|bun|codex|claude) ;;
        zoxide)
            if [ "$(uname -s)" != Linux ]; then
                printf 'zoxide uses Homebrew on macOS; this installer is for Linux.\n' >&2
                exit 2
            fi
            ;;
        git-delta)
            if ! is_ubuntu; then
                printf 'delta uses Homebrew on macOS; this installer is for Ubuntu.\n' >&2
                exit 2
            fi
            ;;
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

install_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")
trap 'rm -rf "$install_temp_dir"' 0

download() {
    if ! command -v curl >/dev/null 2>&1; then
        printf 'curl is required to download publisher installers.\n' >&2
        exit 1
    fi
    curl --proto '=https' --tlsv1.2 -fsSL "$1" -o "$install_temp_dir/installer"
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
            sh "$install_temp_dir/installer" -y --no-modify-path
            ;;
        starship)
            if command -v starship >/dev/null 2>&1 || [ -x "$HOME/.local/bin/starship" ]; then
                printf 'starship is already installed; skipping.\n'
                continue
            fi
            mkdir -p "$HOME/.local/bin"
            printf 'Installing starship from starship.rs...\n'
            download https://starship.rs/install.sh
            sh "$install_temp_dir/installer" -y -b "$HOME/.local/bin"
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
            bash "$install_temp_dir/installer"
            ;;
        codex)
            if command -v codex >/dev/null 2>&1 || [ -x "$HOME/.local/bin/codex" ]; then
                printf 'codex is already installed; skipping.\n'
                continue
            fi
            printf 'Installing Codex from chatgpt.com...\n'
            download https://chatgpt.com/codex/install.sh
            sh "$install_temp_dir/installer"
            ;;
        claude)
            if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
                printf 'claude is already installed; skipping.\n'
                continue
            fi
            if ! command -v bash >/dev/null 2>&1; then
                printf 'Claude Code requires bash. Install it first.\n' >&2
                exit 1
            fi
            printf 'Installing Claude Code from claude.ai...\n'
            download https://claude.ai/install.sh
            bash "$install_temp_dir/installer"
            ;;
        zoxide)
            if command -v zoxide >/dev/null 2>&1 || [ -x "$HOME/.local/bin/zoxide" ]; then
                printf 'zoxide is already installed; skipping.\n'
                continue
            fi
            printf 'Installing zoxide from its Linux installer...\n'
            download https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh
            sh "$install_temp_dir/installer" --bin-dir "$HOME/.local/bin" --man-dir "$HOME/.local/share/man"
            ;;
        git-delta)
            if command -v delta >/dev/null 2>&1; then
                printf 'delta is already installed; skipping.\n'
                continue
            fi
            for required in curl dpkg apt-get sudo; do
                if ! command -v "$required" >/dev/null 2>&1; then
                    printf 'delta requires %s. Install it first.\n' "$required" >&2
                    exit 1
                fi
            done
            architecture=$(dpkg --print-architecture)
            case $architecture in
                amd64|arm64|armhf|i386) ;;
                *)
                    printf 'No supported delta .deb for architecture: %s\n' "$architecture" >&2
                    exit 1
                    ;;
            esac
            printf 'Finding the latest delta release...\n'
            curl --proto '=https' --tlsv1.2 -fsSL https://api.github.com/repos/dandavison/delta/releases/latest -o "$install_temp_dir/release.json"
            delta_version=$(sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' "$install_temp_dir/release.json" | head -n 1)
            case $delta_version in
                ''|*[!0-9A-Za-z._-]*)
                    printf 'Could not read a valid delta release tag.\n' >&2
                    exit 1
                    ;;
            esac
            delta_package="git-delta_${delta_version}_${architecture}.deb"
            printf 'Installing %s from the GitHub release...\n' "$delta_package"
            curl --proto '=https' --tlsv1.2 -fsSL "https://github.com/dandavison/delta/releases/download/${delta_version}/${delta_package}" -o "$install_temp_dir/$delta_package"
            (cd "$install_temp_dir" && sudo apt-get install "./$delta_package")
            ;;
    esac
done
