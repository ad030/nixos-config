{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.desktop =
    {
      pkgs,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        display-manager
        file-manager
        audio

        ## IMPORT THESE MANUALLY IN HOST CONFIGS
        # desktop-environment
        # window-manager
      ];

      services = {
        # Enable power management support for apps
        upower.enable = true;

        # Enable touchpad support (enabled default in most desktopManager).
        libinput.enable = true;

        # Enable CUPS to print documents.
        printing.enable = true;
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };

      environment.systemPackages = with pkgs; [
        foot

        # brightness
        brightnessctl

        # bluetooth
        bluez
        bluez-tools

        # password manager
        bitwarden-desktop

        # ebook reader
        calibre
      ];

      programs = {
        firefox = {
          enable = true;
        };
        localsend = {
          enable = true;
          openFirewall = true;
        };
        nm-applet = {
          enable = true;
        };
      };

    };
}
