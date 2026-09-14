# screenshot script
{
  flake.modules.homeManager.wl-screenshot =
    {
      config,
      pkgs,
      ...
    }:
    let
      baseName = "$(date '+%Y-%m-%d_%H-%M-%S')";
      fileExtension = ".png";
      screenshotsDir = "$HOME/Pictures/Screenshots";
      file = "${screenshotsDir}/${baseName}${fileExtension}";

      wl-screenshot = pkgs.writeShellScriptBin "wl-screenshot" ''
        mkdir -p ${screenshotsDir}
        grim -g "$(slurp)" - | swappy -f - -o "${file}"
      '';
    in
    {
      home.packages = with pkgs; [
        slurp
        grim
        swappy
        wl-clipboard

        wl-screenshot
      ];
    };
}
