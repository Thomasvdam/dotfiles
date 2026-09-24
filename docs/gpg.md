# GPG notes (historical)

These notes came from the old README. Verify commands and current GPG behavior before using them on a new machine.

For Homebrew's macOS pinentry, `~/.gnupg/gpg-agent.conf` may need a `pinentry-program` entry pointing to `pinentry-mac`; restart `gpg-agent` after changing it.

The original key scheme used one offline main key and expiring subkeys per machine or program. To extend a subkey, import the offline main secret, use `gpg --edit-key KEY_ID`, select the subkey with `key INDEX`, use `expire`, then `save`. Remove the main secret from the working machine and import only the exported secret subkeys. Confirm `gpg --list-secret-keys` shows `sec#` for the offline main key, and unmount the offline storage.

Background reading: [Mike Ross's subkey article](https://mikeross.xyz/create-gpg-key-pair-with-subkeys) and [GPG tutorial](https://grimoire.carcano.ch/blog/a-quick-easy-yet-comprehensive-gpg-tutorial).
