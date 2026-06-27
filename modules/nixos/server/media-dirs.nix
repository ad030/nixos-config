{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.media-dirs = {
    # create directories where media is mounted at
    systemd.tmpfiles.settings."homelab-dirs" = {
      "/srv/downloads".d = {
        user = "root";
        group = "media";
        mode = "2775";
      };
      "/srv/media".d = {
        user = "root";
        group = "media";
        mode = "2775";
      };
    };
  };
}
