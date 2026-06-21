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

        # this shit does not work because home manager hasn't updated for lua configuration yet
        settings = {
          bind =
            let
              mod = "SUPER";
              mkBind = keys: command: "hl.bind('${keys}', ${command})";
              exec_cmd = command: "hl.dsp.exec_cmd('${command}')";
            in
            [
              (mkBind "${mod} + D" (exec_cmd "${lib.getExe pkgs.fuzzel}"))
              (mkBind "${mod} + ENTER" (exec_cmd "${lib.getExe pkgs.foot}"))
              (mkBind "${mod} + SHIFT + S" (exec_cmd "wl-screenshot"))

              (mkBind "${mod} + XF86MonBrightnessDown" (exec_cmd "${lib.getExe pkgs.brightnessctl} set 4%-"))
              (mkBind "${mod} + XF86MonBrightnessUp" (exec_cmd "${lib.getExe pkgs.brightnessctl} set +4%"))

              (mkBind "${mod} + XF86AudioMute" (
                exec_cmd "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ))
              (mkBind "${mod} + XF86AudioRaiseVolume" (
                exec_cmd "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+"
              ))
              (mkBind "${mod} + XF86AudioLowerVolume" (
                exec_cmd "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-"
              ))
            ];
        };
      };
    };
}
