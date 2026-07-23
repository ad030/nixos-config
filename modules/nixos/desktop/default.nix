{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.desktop = { pkgs, ... }: {
    imports = with config.flake.modules.nixos; [
      desktop-manager
      display-manager
      window-manager
      home-manager
      audio
    ];

    environment.systemPackages = with pkgs; [
      foot

      # brightness
      brightnessctl

      # bluetooth
      bluez
      bluez-tools

      # unix utilities
      busybox
    ];
  };
}
