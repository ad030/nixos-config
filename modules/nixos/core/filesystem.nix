{ inputs, ... }:
{
  flake.modules.nixos.filesystem = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    # enable logical volume manager
    # not all my systems use it but good to keep it
    boot.initrd.services.lvm.enable = true;

    boot.supportedFilesystems = [
      "zfs"
    ];
  };
}
