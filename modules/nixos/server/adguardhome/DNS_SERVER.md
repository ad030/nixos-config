My stupid garbage "Portal Wifi" router has no option for setting the DNS server
on my local network. This means that no matter what DNS rewrites I set in
AdGuard Home, they will not work.

Until we get a better router with that setting, for now the DNS for each
connection must be manually set.

Since I'm using Network Manager, setting the DNS would look something like this:

```bash
nmcli connection modify <connection-name> ipv4.dns "<dns-server-ip>"
nmcli connection modify <connection-name> ipv4.ignore-auto-dns yes
```

So for example:

```bash
nmcli connection modify CIKTEL_PORTAL_FASTLANE_0624 ipv4.dns "192.168.8.201"
nmcli connection modify CIKTEL_PORTAL_FASTLANE_0624 ipv4.ignore-auto-dns yes
```
