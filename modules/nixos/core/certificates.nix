{
  self,
  ...
}:
{
  flake.modules.nixos.certificates = {

    # trusted public ssl root certificates
    # needed for https connections to my homelab
    security.pki.certificateFiles = [
      # located at root/certs of config
      (self + "/certs/rootCA.pem")
    ];

    # compromised root ca
    # https://emudhra.we-have-a-problem.com/
    security.pki.caCertificateBlacklist = [
      "Comodo AAA Services root"
      "emSign ECC Root CA - G3"
    ];
  };
}
