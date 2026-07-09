{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.niri.homeModules.niri
        self.modules.homeManager.wl-screenshot
        self.modules.homeManager.idle-daemon
      ];

      home.packages = with pkgs; [
        swaybg
        quickshell
      ];

      programs.niri = {
        settings = {
          spawn-at-startup =
            let
              wallpaper = self.images.ow-archaeologist-cover;
              terminal = pkgs.foot;
              statusBar = pkgs.quickshell;
            in
            [
              {
                argv = [ "${lib.getExe statusBar}" ];
              }
              {
                argv = [
                  "${lib.getExe terminal}"
                  "--server"
                ];
              }
              {
                argv = [
                  "${lib.getExe pkgs.swaybg}"
                  "-m"
                  "fill"
                  "-i"
                  wallpaper
                ];
              }
              {
                argv = [
                  "${lib.getExe pkgs.swayidle}"
                  "-w"
                ];
              }
              {
                argv = [
                  "${lib.getExe' pkgs.xdg-user-dirs "xdg-user-dirs-update"}"
                ];
              }
            ];

          input = {
            focus-follows-mouse = {
              enable = false;
            };
          };

          xwayland-satellite = {
            enable = true;
            path = lib.getExe pkgs.xwayland-satellite-unstable;
          };

        };
      };
    };
}
