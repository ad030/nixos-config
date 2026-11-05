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
        X11Forwarding = "false";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
