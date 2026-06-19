{
  self,
  inputs,
  ...
}:
{
  flake.modules.hm.hyprland = {
    wayland.windowManager.hyprland = {
      enable = true;

      # use hyprland package from nixos system
      package = null;
      portalPackage = null;

      settings = {
        "$mod" = "SUPER";

        bind = [
          "$mod, D, exec, fuzzel"
          "$mod, ENTER, exec, foot"
        ];
      };
    };
  };
}
