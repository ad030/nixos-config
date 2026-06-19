{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.supportedFilesystems = [ "nfs" ];
  services.nfs.server.enable = true;

  # use NFSv4
  services.nfs.server.nfsd = {
    vers4 = true;
    vers3 = false;
    vers2 = false;
  };

  # create /export directory to use for nfs exports
  systemd.tmpfiles.settings.home-srv = {
    "/export".d = {
      user = "nobody";
      group = "nogroup";
      mode = "0755";
      age = "-";
      argument = "";
    };
  };

  # bind nfs
  fileSystems = {
    "/export/media-share" = {
      device = "/mnt/tank";
      options = [ "bind" ];
    };
  };

  services.nfs.server.exports = ''
    /export               192.168.8.0/24(ro,fsid=0,no_subtree_check)
    /export/media-share   192.168.8.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
  '';

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
