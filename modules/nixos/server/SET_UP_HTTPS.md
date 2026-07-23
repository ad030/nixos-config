> [!NOTE]
> The `mkcert` commands in this file are expected to be run as the root user in
> the _/root_ directory on the server machine.
>
> Therefore domain certificates will be located at _/root_ and the root
> certificate will be located at _/root/.local/share/mkcert_.

To access home server websites through HTTPS, SSL certificates are needed.

On initial setup, first generate the root certificate.

```bash
# mkcert -install
Created a new local CA 💥
Installing to the system store is not yet supported on this Linux 😣 but Firefox and/or Chrome/Chromium will still work.
You can also manually install the root certificate at "/root/.local/share/mkcert/rootCA.pem".
```

In NixOS, the root certificate needs to be installed manually in the config.
Copy the path to the key returned by mkcert (or run `mkcert -CAROOT` to find the
path):

```nix
security.pki.certificateFiles = [
  "/root/.local/share/mkcert/rootCA.pem"
];
```

Next, generate domain certificates as needed. A wildcard certificate (created
with an asterisk in the domain name) covers a base domain name and all its
subdomains.

```bash
# mkcert "*.home.lan"
Note: the local CA is not installed in the system trust store.
Run "mkcert -install" for certificates to be trusted automatically ⚠️

Created a new certificate valid for the following names 📜
 - "*.home.lan"

Reminder: X.509 wildcards only go one level deep, so this won't match a.b.home.lan ℹ️

The certificate is at "./_wildcard.home.lan.pem" and the key at "./_wildcard.home.lan-key.pem" ✅

It will expire on 23 October 2028 🗓
```
