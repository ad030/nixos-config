# Enable the OpenSSH daemon.
{
  flake.modules.nixos.ssh = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
    };
  };
}
