# Enable the OpenSSH daemon.
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        LogLevel = "VERBOSE";
        X11Forwarding = false;
        MaxAuthTries = 7;
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
