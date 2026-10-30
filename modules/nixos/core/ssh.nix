# Enable the OpenSSH daemon.
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        LogLevel = "verbose";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
