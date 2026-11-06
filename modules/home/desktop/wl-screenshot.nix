# screenshot script
{
  flake.modules.homeManager.wl-screenshot =
    {
      config,
      pkgs,
      ...
    }:
    let
      baseName = "%Y-%m-%d_%H-%M-%S";
      fileExtension = "png";
      screenshotsDir = "$HOME/Pictures/Screenshots";

      wl-screenshot = pkgs.writeShellScriptBin "wl-screenshot" ''
        mkdir -p ${screenshotsDir}
        grim -g "$(slurp)" - | swappy -f -
      '';
    in
    {
      home.packages = with pkgs; [
        slurp
        grim
        wl-clipboard

        wl-screenshot
      ];

      programs = {
        swappy = {
          enable = true;
          settings = {
            Default = {
              save_dir = screenshotsDir;
              save_filename_format = "${baseName}.${fileExtension}";
            };
          };
        };
      };
    };
}
