{
  flake.modules.nixos.bootloader =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {
      boot.loader = {
        systemd-boot = {
          enable = true;
          # graceful = true;
          configurationLimit = 7;
        };
        efi.canTouchEfiVariables = true;
        timeout = lib.mkDefault 10;
      };
    };
}
