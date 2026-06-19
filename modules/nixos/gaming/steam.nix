{
  flake.modules.nixos.steam =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
      };
    };
}
