# generate flake.images.<wallpaper> for each image file in ./_wallpapers/
{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.images =
    let
      wallpaperDir = ./_wallpapers;
      files = builtins.attrNames (builtins.readDir wallpaperDir);
    in
    builtins.listToAttrs (
      map (f: {
        name = lib.removeSuffix ".png" (lib.removeSuffix ".jpg" f);
        value = builtins.path {
          path = wallpaperDir + "/${f}";
          name = f;
        };
      }) files
    );
}
