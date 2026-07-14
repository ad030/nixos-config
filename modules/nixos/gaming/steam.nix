{
  flake.modules.nixos.steam =
    {
      config,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.protonup-qt
      ];

      # steam on niri with xwayland-satellite spawns black square
      # fix is to add this flag
      # https://discourse.nixos.org/t/niri-xwayland-satellite-black-steam-window-fix/77107
      nixpkgs.overlays = [
        (final: prev: {
          steam = prev.steam.override {
            extraArgs = "-cef-disable-gpu-compositing";
          };
        })
      ];

      programs.steam = {
        enable = true;
        protontricks.enable = true;

        extraCompatPackages = [
          # pkgs.proton-ge-bin
        ];
      };
    };
}
