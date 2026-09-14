let
  baseName = "%Y-%m-%d %H%M%S";
  screenshotsDir = "$HOME/Pictures/Screenshots";
in
{
  flake.modules.homeManager.flameshot = {
    services = {
      flameshot = {
        enable = true;
        settings = {
          savePath = screenshotsDir;
          filenamePattern = baseName;
          saveAsFileExtension = ".png";
        };
      };
    };
  };
}
