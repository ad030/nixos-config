{
  flake.modules.homeManager.art =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      home.packages = with pkgs; [
        krita
        gimp
        kdePackages.kdenlive
        blender

        # aseprite
      ];
    };
}
