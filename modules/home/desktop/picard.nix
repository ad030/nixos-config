# music tagging software
{
  flake.modules.homeManager.picard =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        picard
      ];

      xdg.mimeApps.associations.added = {
        "inode/directory" = [
          "org.musicbrainz.Picard.desktop"
        ];
      };
    };
}
