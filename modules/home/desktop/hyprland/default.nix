{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.hyprland =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        self.modules.homeManager.wl-screenshot
      ];

      wayland.windowManager.hyprland = {
        enable = true;

        # use hyprland package from nixos system
        package = null;
        portalPackage = null;

        systemd.enable = false; # try uwsm

        # use lua config available since hyprland 0.55
        configType = "lua";

        # configuring hyprland lua in home manager stinks booty
        # just import everything from another file
        extraConfig =
          let
            rf = builtins.readFile;
          in
          ''
            ${rf ./_modules/monitor.lua}
            ${rf ./_modules/env.lua}
            ${rf ./_modules/anim.lua}
            ${import ./_modules/binds.nix { inherit pkgs lib; }}
          '';

      };
    };
}
