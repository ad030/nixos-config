{ self, inputs, ... }:
{
  flake.modules.hm.wl-screenshot =
    {
      config,
      pkgs,
      ...
    }:
    let
      basename = "$(date +%Y-%m-%d_%H%M%S).png";
      screenshot_dir = "$HOME/Pictures/Screenshots";
      wl-screenshot = pkgs.writeShellScriptBin "wl-screenshot" ''
        mkdir -p ${screenshot_dir}
        grim -g "$(slurp)" - | tee ${screenshot_dir}/${basename} | wl-copy --paste-once
      '';
    in
    {
      home.packages = with pkgs; [
        slurp
        grim
        wl-clipboard
        wl-screenshot
      ];
    };
}
