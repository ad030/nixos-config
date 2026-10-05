{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  hostname = "attlerock";
  nixpkgs = inputs.nixpkgs;
  hostPlatform = "x86_64-linux";
in
{
  flake.nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.hostPlatform = hostPlatform; }
      ./_nixos
      { networking.hostName = hostname; }
      { nixpkgs.config.allowUnfree = true; }
    ]
    # nixos modules
    ++ (with config.flake.modules.nixos; [
      core
      server

      containers-technitium # dns server

      # notifications
      containers-ntfy # notifications

      containers-freshrss
      containers-jellyfin
      containers-slskd
      containers-qbittorrent
      containers-calibre-web-automated
      containers-radarr
      containers-navidrome
      containers-sonarr
      containers-vaultwarden

      containers-kiwix-serve # local wikipedia

      # containers-aria2 # download manager
    ]);
  };
}
