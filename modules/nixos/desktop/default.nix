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
        ssl-root-certs

        display-manager
        home-manager
        audio

        ## IMPORT THESE MANUALLY IN HOST CONFIGS
        # desktop-environment
        # window-manager
      ];

      environment.systemPackages = with pkgs; [
        foot

        # brightness
        brightnessctl

        # bluetooth
        bluez
        bluez-tools
      ];
    };
}
