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
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
        timeout = lib.mkDefault 10;
      };
    };
}
