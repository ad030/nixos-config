{
  flake.modules.nixos.package-caches =
    {
      config,
      pkgs,
      ...
    }:

    {
      nix.settings = {
        substituters = [
          "https://cache.nixos.org"
          "https://niri.cachix.org"
          "https://vicinae.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        ];
      };
    };
}
