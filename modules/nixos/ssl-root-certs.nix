{
  self,
  inputs,
  ...
}:
{
  # trusted public ssl root certificates
  flake.modules.nixos.ssl-root-certs = {
    security.pki.certificateFiles = [
      (self + "/certs/rootCA.pem")
    ];
  };
}
