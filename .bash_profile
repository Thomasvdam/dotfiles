#!/usr/bin/env bash

# Default path.
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Users/t.vandam/Library/Application\ Support/Fusetools/Fuse/Android/AndroidSDK/platform-tools;
export ANDROID_HOME=/Users/t.vandam/Library/Application\ Support/Fusetools/Fuse/Android/AndroidSDK;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Activate the currently selected version of node.
nvm use node;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
