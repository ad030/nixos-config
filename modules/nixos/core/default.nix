{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.core =
    {
      config,
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
      ];

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
        };
      };

      environment.systemPackages = with pkgs; [
        neovim
        wget
        curl
        git
        bash
        python314
        jq
        htop

        # notifications
        libnotify
        mako

        # nix programming; language server, formatter
        nil
        nixfmt
      ];

    };
}
