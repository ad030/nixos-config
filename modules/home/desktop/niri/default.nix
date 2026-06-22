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
      ];

      home.packages = with pkgs; [
        swaybg
      ];

      programs.niri = {
        settings = {

          spawn-at-startup =
            let
              wallpaper = self.images.solar-system;
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
