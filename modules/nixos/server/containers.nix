# shared config across containers
{
  flake.modules.nixos.containers = {
    virtualisation.oci-containers = {
      backend = "podman";
    };
  };
}
