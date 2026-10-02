# shared config across containers
{
  flake.modules.nixos.containers-core = {
    virtualisation.oci-containers = {
      backend = "podman";
    };

    # for storing container data
    systemd.tmpfiles.settings."container-data" = {
      "/srv/config".d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
  };
}
