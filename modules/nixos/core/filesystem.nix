{ inputs, ... }:
{
  flake.modules.nixos.filesystem = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    # enable logical volume manager
    # not all my systems use it but good to keep it
    boot.initrd.services.lvm.enable = true;

    # enable filesystems
    boot.supportedFilesystems = [
      "zfs"
      "nfs"
    ];
    boot.zfs.forceImportRoot = false;

    boot.initrd.kernelModules = [
      "nfs"
    ];

  };
}
