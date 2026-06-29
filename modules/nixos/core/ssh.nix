# Enable the OpenSSH daemon.
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
      settings.PasswordAuthentication = false;
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
