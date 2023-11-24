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
6. Run the Rustup installer in the `rust` directory.
7. Run the Homebrew installer in the `homebrew` directory.
8. Install a whole bunch of packages and binaries by running `brew bundle` from the root of the repository. This should set you up with all of the frequenctly used command line tools as well as applications.
9. Install the `JetBrains Mono` and `JetBrainsMono NF` (Nerd Font). If anything goes wrong with fonts later double check the names in `Font Book` and whatever config file the application giving issues uses.
10. Now it's time to bootstrap all the config files and pollute the home directory! Given that we installed all the binaries in previous steps you should now be ok to boot up `Alacritty` and dump the terminal session used to get to this point.
11. If anything goes wrong past me apologises but you're on your own now. :)

## Setup GPG

To avoid having to download the GPG suite which prompts for signing up every occasion we install GPG through homebrew and set it up ourselves. This includes setting an ENV variable as well as downloading and configuring one extra dependency to handle the pint entry. Why this doesn't work out of the box I don't know.

```sh
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
```

### Key Setup

I opted to go for one 'main' key that doesn't expire as this is a false sense of security; if someone has the main key they can extend the expiration date anyway. Instead I keep copies of the revocation certificate around should I ever lose access to the main key.

For day-to-day use I keep subkeys per system/program that do have an expiry date set. These can also be extended through the main key, so there is no complicated key rotation required (if I am well informed).

### Extending Expiry Dates

Just some notes because it's not a frequent occurence and I don't want to spend time digging up resources every X months. My main sources were (this excellent blog post)[https://mikeross.xyz/create-gpg-key-pair-with-subkeys] and (this amazing reference/tutorial)[https://grimoire.carcano.ch/blog/a-quick-easy-yet-comprehensive-gpg-tutorial].

#### Subkeys

1. Attach cold storage that holds the secret of the 'main' key. (If it's not on cold storage than why bother with all this? :D )
2. `gpg --import <PATH_TO_MAIN_SECRET>`. Enter the passphrase assoctiated with the key.
3. `gpg --edit-key <KEY_ID>`. This will open the `gpg` prompt.
4. `> key <SUBKEY_INDEX>`. Select the key you want to extend.
5. `> expire`. Follow the prompts to set the new expiry date.
6. `> save`. Saves the new key info and exits the `gpg` prompt.
7. `gpg --delete-secret-keys <KEY_ID>`. Confirm the prompts.
8. `gpg --import <PATH_TO_SUBKEY_SECRET>`. Enter the passphrase again.
9. `gpg --list-secret-keys`. Just to double check, this should show `sec#` to indicate only the secret subkey exists, not the secret main key.
10. Don't forget to unmount the cold storage again. :)

## Inspiration & Sources

Initial work mostly based on the work of Mathias Bynens: https://github.com/mathiasbynens/dotfiles  
Later upgraded based on the work of Zach Holman: https://github.com/holman/dotfiles

Both are equally interesting repos to dive into in order to learn more about dotfiles. Mathias' has an extensive .osx file which has a lot of neat tricks.

