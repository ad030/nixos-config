# My NixOS Configuration

Shamelessly copied 99% of this from
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
