{
  self,
  inputs,
  ...
}:
{
  # trusted public ssl root certificates
  # needed for https connections to my homelab
  flake.modules.nixos.ssl-root-certs = {
    security.pki.certificateFiles = [
      (self + "/certs/rootCA.pem")
    ];
  };
}
