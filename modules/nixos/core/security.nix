{
  flake.modules.nixos.security =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        firejail
      ];

      security = {
        rtkit.enable = true;
      };
    };
}
