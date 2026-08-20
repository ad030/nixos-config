{
  config,
  ...
}:
{
  flake.modules.nixos.dev =
    {
      pkgs,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        distrobox
      ];

      environment.systemPackages = with pkgs; [
        sqlite
      ];
    };
}
