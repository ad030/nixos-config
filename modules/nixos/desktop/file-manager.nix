{
  flake.modules.nixos.file-manager = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gvfs
      # needed for file managers
      lxmenu-data
      # menu-cache
      shared-mime-info
    ];

    xdg.menus.enable = true;

    services.gvfs.enable = true;
  };
}
