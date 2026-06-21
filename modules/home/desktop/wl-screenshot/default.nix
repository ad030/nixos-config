{ self, inputs, ... }:
{
  flake.modules.homeManager.wl-screenshot =
    {
      config,
      pkgs,
      ...
    }:
    let
      basename = "$(date +%Y-%m-%d_%H%M%S).png";
      screenshots_dir = "$HOME/Pictures/Screenshots";
      file = "${screenshots_dir}/${basename}";

      wl-screenshot = pkgs.writeShellScriptBin "wl-screenshot" ''
        mkdir -p ${screenshots_dir}
        grim -g "$(slurp)" - | swappy -f - -o ${file} && \
          wl-copy --paste-once < ${file}
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
