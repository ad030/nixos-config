# My NixOS Configuration

I shamelessly copied 99% of this from
[GaetanLepage's configuration](https://github.com/GaetanLepage/nix-config).

## Devices

Hostnames and usernames come from the 2019 video game _Outer Wilds_. Hostnames
are based on locations. Usernames are based on characters.

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
