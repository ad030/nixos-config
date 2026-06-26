# My NixOS Configuration

I shamelessly copied 99% of this from
[GaetanLepage's configuration](https://github.com/GaetanLepage/nix-config).

## Devices

Each device gets its hostname from planets in the 2019 video game _Outer Wilds_.
Users are also named after characters from the game.

| Hostname         | Description           |
| ---------------- | --------------------- |
| `brittle-hollow` | My laptop             |
| `timber-hearth`  | My primary desktop PC |
| `attlerock`      | My home server host   |

## Updating

Package versions are locked by flake.lock. To update run `nix flake update` and
then rebuild the system.

## Secrets

Secrets are encrypted in `secrets/secrets.yaml`. To unlock them, the host must
have an age key in the `.sops.yaml` file.

Each host derives an age key from its SSH host key located at
`/etc/ssh/ssh_host_id25519_key`.

### Unlocking secrets on new host using sops and age

If decryption fails, it is impossible to log into any user because user
passwords are also stored in `secrets/secrets.yaml`. As a last resort, the root
user can be used to log in and fix it. The root user is not intended to be used
otherwise.
