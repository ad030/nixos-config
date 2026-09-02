{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.core =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        bootloader
        network
        package-caches
        nix-settings
        fonts
        users-settings
        ssh
        security
        secret-service
        sops
        filesystem
        power-management
        printing
        tailscale
      ];

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
        };
      };

      environment.systemPackages = with pkgs; [
        # unix utilities
        busybox
        outils
        gdu
        bat
        btop
        htop

        lshw

        neovim
        wget
        curl
        git
        bash
        python314
        jq

        # notifications
        libnotify
        mako

        # nix programming; language server, formatter
        nil
        nixfmt
      ];

    };
}
