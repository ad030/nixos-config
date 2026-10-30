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
        core
        distrobox
      ];

      environment.systemPackages = with pkgs; [
        man-pages

        # nix programming; language server, formatter
        nil
        nixfmt
      ];
    };
}
