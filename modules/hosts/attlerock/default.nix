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

      # specific containers
      containers-technitium # dns server

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

      containers-forgejo
    ])
    # generate shared stub users on this system for each regular user
    # >> NECESSARY FOR NFS PERMISSIONS TO WORK! <<
    # there needs to be a user on both server and client with matching uids
    ++ [
      {
        users.users = lib.mapAttrs (_: user: {
          uid = user.uid;
          isSystemUser = true;
          group = "nogroup";
          extraGroups = user.groups;
          hashedPassword = "!";
        }) self.lib.sharedIds.users;
      }
    ];
  };
}
