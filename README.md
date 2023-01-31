# Dotfiles and defaults

Learned the hard way that setting your defaults manually is a bad idea if you ever want to do a clean reinstall...

## Setup

Notes to future self, making some assumptions here that it'll be a macOS system of some sort.

1. Create a new SSH key, use default values or err on the side of more secure, and add it to your GH SSH keys. This would also be a good time to verify all other SSH keys in there are still secure and in use.
2. After doing the initial Apple setup start up Disk Utilities and create a case sensitive partition. This is where all code and projects should go so don't be stingy when determining the size.  
You might want to symlink the partition from your home directory, but not a hard requirement.
3. In your fancy new partition find a sweet spot to clone this repository.
4. Don't forget to checkout the submodules `git submodule update --init`.
5. Run the setup file in the `macOS` directory, this sets some system preferences to my liking, but not all so be prepared to dive into the system preferences from time to time (and perhaps spend some time to see if it can be added to the script).
6. Run the Homebrew installer in the `homebrew` directory.
7. Install a whole bunch of packages and binaries by running `brew bundle` from the root of the repository. This should set you up with all of the frequenctly used command line tools as well as applications.
8. Install the `JetBrains Mono` and `JetBrainsMono NF` (Nerd Font). If anything goes wrong with fonts later double check the names in `Font Book` and whatever config file the application giving issues uses.
9. Now it's time to bootstrap all the config files and pollute the home directory! Given that we installed all the binaries in previous steps you should now be ok to boot up `Alacritty` and dump the terminal session used to get to this point.
10. If anything goes wrong past me apologises but you're on your own now. :)

## Inspiration & Sources

Initial work mostly based on the work of Mathias Bynens: https://github.com/mathiasbynens/dotfiles  
Later upgraded based on the work of Zach Holman: https://github.com/holman/dotfiles

Both are equally interesting repos to dive into in order to learn more about dotfiles. Mathias' has an extensive .osx file which has a lot of neat tricks.

