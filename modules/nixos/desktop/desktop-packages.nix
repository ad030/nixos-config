{
  flake.modules.nixos.desktop-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        foot

        fastfetch

        # bluetooth
        bluez
        bluez-tools
      ];
    };
}
