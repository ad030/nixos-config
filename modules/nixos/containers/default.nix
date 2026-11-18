{
  config,
  ...
}@top:
{
  flake.modules.nixos.containers =
    {
      config,
      ...
    }:
    let
      interfaces = {
        lan = builtins.attrNames config.networking.interfaces;
        wg = builtins.attrNames config.networking.wireguard.interfaces;
      };
    in
    {
      imports = with top.config.flake.modules.nixos; [
        core
      ];

      # this check is done in modules/core/ssh.nix
      # assertions = [
      #   {
      #     assertion = (interfaces.lan) != [ ];
      #     message = "No trusted LAN interfaces found.";
      #   }
      # ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };
    };
}
