# Dotfiles

This repository uses [chezmoi](https://www.chezmoi.io/) for persistent configuration on my own Macs and Linux machines.

Chezmoi reads the `home/` directory (selected by `.chezmoiroot`). Its `dot_` files become dotfiles, `executable_` installs scripts as executables, and `.chezmoiignore` selects OS- and role-specific files. On initialization, chezmoi asks whether this owned machine is a `workstation` or `server` and saves the answer in its local config. Package lists are rendered into `~/.config/dotfiles/packages/`; installing packages remains a separate step. Older symlink sources remain for migration.

## Fresh personal Mac

1. Set up SSH access to GitHub, then [install chezmoi](https://www.chezmoi.io/install/) (Homebrew's `brew install chezmoi` is also fine if Homebrew is already installed).
2. Clone the repo into chezmoi's default source directory. Choose `workstation` when prompted, then inspect what will be installed:

   ```sh
   chezmoi init git@github.com:Thomasvdam/dotfiles.git
   chezmoi diff
   chezmoi apply --interactive
   ```

3. Create `~/.gitconfig.local` with your identity, signing key, and credential helper. See [the example](examples/gitconfig.local). Keep this file private and out of Git. On Mac, the shared config enables commit signing and Delta; install and configure both before relying on those settings.
4. Optionally install [Homebrew](https://brew.sh/) and the curated Mac packages. Review the list before running it:

   ```sh
   cat ~/.config/dotfiles/packages/Brewfile
   brew bundle check --file ~/.config/dotfiles/packages/Brewfile
   brew bundle --no-upgrade --file ~/.config/dotfiles/packages/Brewfile
   ```

5. Optionally run `macos/set-defaults.sh` from the repository root (the parent of `chezmoi source-path`) after reviewing its system changes. Install your preferred font separately if Ghostty cannot find `JetBrainsMono NF`.

The workstation list includes GUI casks; a Mac with the `server` role gets only the common command-line packages and no Ghostty or Hammerspoon config. For apps with their own updater, the casks are a convenient first install and the app owns subsequent updates. `--no-upgrade` prevents `brew bundle` from upgrading already installed packages. Starship and Bun use the publisher installer described below. Codex remains a separate install. Open a new shell after applying. Package installation and macOS defaults are never automatic during `chezmoi apply` or `chezmoi update`.

## Fresh owned Linux server

1. Install chezmoi using its [binary installer](https://www.chezmoi.io/install/) or your distribution's package manager. Choose `server` when prompted, then inspect as above:

   ```sh
   chezmoi init git@github.com:Thomasvdam/dotfiles.git
   chezmoi diff
   chezmoi apply --interactive
   ```

2. Create `~/.gitconfig.local` with at least your name and email. Enable signing there only if that machine has a usable key. Linux does not receive the Mac-only Hammerspoon or Ghostty configuration.
3. For an owned Debian/Ubuntu machine, optionally review and install the modest CLI list:

   ```sh
   cat ~/.config/dotfiles/packages/apt.txt
   repo=$(dirname "$(chezmoi source-path)")
   "$repo/packages/linux/install-apt.sh"
   ```

   Other distributions need their own package list. A Linux `workstation` adds Go and Graphviz to this list; `server` keeps the smaller base. Shell startup checks for optional programs, so installing this list is not required for a usable shell.

The managed `~/.bashrc` loads the shared aliases and functions. Zsh is also supported if you choose it as your interactive shell. This setup does not change your login shell, install services, or provision the VPS.

## Tools installed outside package managers

On an owned Mac or Linux machine, install selected tools explicitly from the repository root (the parent of `chezmoi source-path`):

```sh
./tools/install.sh rustup starship bun
```

The script downloads each publisher's installer over HTTPS and runs it as your user. Review [Rustup's](https://rustup.rs/), [Starship's](https://starship.rs/), and [Bun's](https://bun.sh/docs/installation) installers before running the command. It installs Rustup under `~/.cargo`, Starship in `~/.local/bin`, and Bun under `~/.bun`; the managed shells already load those paths. Linux needs `unzip` for Bun. Run any subset of the names, in any order. Existing commands are skipped, including installations from Homebrew, so the script will not replace their update channel. Open a new shell after installation. The managed `~/.bunfig.toml` sets a seven-day minimum release age for Bun packages.

For updates, keep using the original install channel: `rustup update` for Rust, `bun upgrade` for Bun, and the [Starship installer](https://starship.rs/faq/) again for a directly installed Starship. If a tool was installed with Homebrew, update it with Homebrew instead. These tool installs and updates never run during `chezmoi apply` or `chezmoi update`.

## Keeping owned machines in sync

Change managed files in chezmoi's source directory (`chezmoi cd`), commit, and push through Git. On another owned machine, use the one-step update:

```sh
chezmoi update
```

`chezmoi update` pulls the repository and applies its managed files. To inspect incoming changes first, run `chezmoi git -- pull --ff-only`, then `chezmoi diff` and `chezmoi apply --interactive`. Neither workflow installs or upgrades packages. If you edit a managed file directly in your home directory, use `chezmoi add FILE` to bring that change into the source, or `chezmoi edit FILE` to edit the source directly.

## Machine-specific settings

- `~/.gitconfig.local` holds Git identity, signing key, and credential helper. The shared `.gitconfig` includes it.
- `~/.config/dotfiles/local.sh` is an optional, untracked shell hook sourced on owned machines. Keep it compatible with Bash and Zsh. The older `~/.zshlocals` hook still works in Zsh during migration.
- The local `role` is `workstation` or `server`; the OS comes from chezmoi. Mac workstation-only files are selected by `.chezmoiignore`. For machine-specific nonsecret files that should travel through Git, add a narrowly scoped chezmoi template or ignore rule rather than hardcoding a home path into shared config. The role is stored locally in `~/.config/chezmoi/chezmoi.toml` under `[data]`. Edit that value, review `chezmoi diff`, then run `chezmoi apply` to change roles. Chezmoi does not delete files that become ignored; remove old Mac GUI config manually if you switch an existing workstation to `server`.

The portable shell subset is in `home/dot_config/dotfiles/shell/aliases.sh` and `functions.sh`. Personal-only tool aliases and Mac-specific commands are in adjacent files. `home/dot_zshrc` and `home/dot_bashrc` load them on owned machines. Chezmoi renders the same portable files into one standalone remote Bash rc.

## Shared/work servers

After applying on your local Mac or Linux workstation, run:

```sh
rssh some-host
rssh -J jump-host -p 2222 some-host
```

Put SSH connection options before the host; the host must be last. `rssh` uses your ordinary SSH configuration and authentication. It writes the rendered Bash rc into a new temporary directory on the server (`mktemp -d` under `$TMPDIR` or `/tmp`) on each invocation, then opens an interactive Bash session with `bash --rcfile ... -i`. That file attempts to source the usual login profiles (`/etc/profile`, then the first readable of `~/.bash_profile`, `~/.bash_login`, and `~/.profile`) before the portable aliases and functions. The temporary directory is removed when the session exits. The remote side needs Bash and common core utilities. No root, Git, chezmoi, Homebrew, or other personal tooling is required there.

The upload is private to your remote account and is only loaded by `rssh`. It does not edit `.bashrc`, `.profile`, `.zshrc`, or any other login file. `ssh some-host` remains a normal session. `rssh` does not forward a remote command or support SSH modes that disable an interactive shell.

TODO:
- Check other existing dotfiles/config files
- Decide whether other tools such as Codex or Claude need publisher installers.
