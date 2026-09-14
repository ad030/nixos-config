let
  baseName = "%Y-%m-%d %H%M%S";
in
{
  flake.modules.homeManager.flameshot =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        grim
      ];

      services = {
        flameshot = {
          enable = true;
          settings = {
            General = {
              filenamePattern = baseName;
              saveAsFileExtension = ".png";

              # these are unrecognized apparently
              # useGrimAdapter = true;
              # disabledGrimWarning = true;
            };
          };
        };
      };
    };
}
