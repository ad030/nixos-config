{
  self,
  ...
}:
{
  flake.modules.nixos.certificates = {
    # trusted public ssl root certificates
    security.pki.certificateFiles = [
      # needed for https connections to my homelab
      # located at root/certs of config
      (self + "/certs/rootCA.pem")
    ];

    security.pki.caCertificateBlacklist = [
      # compromised root ca
      # https://emudhra.we-have-a-problem.com/
      "Comodo AAA Services root"
      # "emSign ECC Root CA - G3"
    ];
  };
}
