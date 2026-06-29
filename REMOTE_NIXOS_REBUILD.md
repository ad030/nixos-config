To remotely rebuild a system, you can use the
`--target-host <user>@<ip-address>` flag in nixos-rebuild.

```bash
nixos-rebuild switch --flake .#<nixos-config-hostname> --target-host <user>@<ip-address>
```

In my case, I use the root user and rebuild from a machine with an authorized
SSH key.

So to rebuild the system with address 192.168.8.201 with the NixOS configuration
for hostname "attlerock":

```bash
nixos-rebuild switch --flake .#attlerock --target-host root@192.168.8.201
```
