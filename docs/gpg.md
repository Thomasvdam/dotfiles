# Setup GPG

To avoid having to download the GPG suite which prompts for signing up every occasion we install GPG through homebrew and set it up ourselves. This includes setting an ENV variable as well as downloading and configuring one extra dependency to handle the pint entry. Why this doesn't work out of the box I don't know.

```sh
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
```

## Key Setup

I opted to go for one 'main' key that doesn't expire as this is a false sense of security; if someone has the main key they can extend the expiration date anyway. Instead I keep copies of the revocation certificate around should I ever lose access to the main key.

For day-to-day use I keep subkeys per system/program that do have an expiry date set. These can also be extended through the main key, so there is no complicated key rotation required (if I am well informed).

## Extending Expiry Dates

Just some notes because it's not a frequent occurence and I don't want to spend time digging up resources every X months. My main sources were (this excellent blog post)[https://mikeross.xyz/create-gpg-key-pair-with-subkeys] and (this amazing reference/tutorial)[https://grimoire.carcano.ch/blog/a-quick-easy-yet-comprehensive-gpg-tutorial].

### Subkeys

1. Attach cold storage that holds the secret of the 'main' key. (If it's not on cold storage than why bother with all this? :D )
2. `gpg --import <PATH_TO_MAIN_SECRET>`. Enter the passphrase assoctiated with the key.
3. `gpg --edit-key <KEY_ID>`. This will open the `gpg` prompt.
4. `> key <SUBKEY_INDEX>`. Select the key you want to extend. You'll want to select the encryption and signing subkeys.
5. `> expire`. Follow the prompts to set the new expiry date.
6. `> save`. Saves the new key info and exits the `gpg` prompt.
7. `gpg --delete-secret-keys <KEY_ID>`. Confirm the prompts.
8. `gpg --import <PATH_TO_SUBKEY_SECRET>`. Enter the passphrase again.
9. `gpg --list-secret-keys`. Just to double check, this should show `sec#` to indicate only the secret subkey exists, not the secret main key.
10. Don't forget to unmount the cold storage again. :)
