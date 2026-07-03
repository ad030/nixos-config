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
      ];

      programs.niri = {
        settings = {
          spawn-at-startup =
            let
              wallpaper = self.images.ow-archaeologist-cover;
            in
            [
              {
                argv = [ "${lib.getExe pkgs.waybar}" ];
              }
              {
                argv = [
                  "${lib.getExe pkgs.foot}"
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
            ];

          input = {
            focus-follows-mouse = {
              enable = false;
            };
          };

        };
      };
    };
}
