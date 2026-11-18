# Enable the OpenSSH daemon.

{
  flake.modules.nixos.ssh =
    {
      config,
      lib,
      ...
    }:
    let
      interfaces = {
        lan = builtins.attrNames config.networking.interfaces;
        wg = builtins.attrNames config.networking.wireguard.interfaces;
      };
    in
    {
      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          LogLevel = "VERBOSE";
          X11Forwarding = false;
          # MaxAuthTries = 7;
        };
      };

      assertions = [
        {
          assertion = interfaces.lan != [ ];
          message = "No trusted LAN interfaces found.";
        }
      ];

      # open only for specific interfaces
      networking.firewall.interfaces = lib.genAttrs (interfaces.lan ++ interfaces.wg) (_: {
        allowedTCPPorts = [ 22 ];
      });
    };
}
