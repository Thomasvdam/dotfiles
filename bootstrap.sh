#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "hammerspoon/" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
		--exclude "colourschemes/" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

# Set up and copy hammerspoon preferences
read -p "This may overwrite existing files in your hammerspoon directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	mkdir -p "$HOME/.hammerspoon";
	cp -r "hammerspoon/." "$HOME/.hammerspoon/";
	echo "Created ~/.hammerspoon and copied contents of ./hammerspoon.";
fi;
