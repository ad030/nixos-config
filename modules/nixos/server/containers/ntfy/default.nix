{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-ntfy =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "ntfy";
      directories = {
        config = "/srv/config/ntfy/config";
        cache = "/var/cache/ntfy/cache";
      };
      ids = {
        user = {
          ${username} = 2004;
        };
      };

      webPort = "8082";
    in
    {
      virtualisation.oci-containers.containers = {
        ntfy = {
          image = "docker.io/binwiederhier/ntfy:v2.28@sha256:6ef4b819f722fccdc036af611c4774cfdc2de821ab74fdd48bbf4c9d6f8973da";
          hostname = "ntfy";
          user = "${toString config.users.users.${username}.uid}:${
            toString config.users.groups.${username}.gid
          }";
          cmd = [
            "serve"
          ];
          ports = [
            "127.0.0.1:8082:8082/tcp"
          ];
          volumes = [
            "${directories.cache}:/var/cache/ntfy"
            "${directories.config}:/etc/ntfy"
          ];
          environment = {
            NTFY_BASE_URL = "http://ntfy.home.lan";
            NTFY_LISTEN_HTTP = ":8082";
            NTFY_BEHIND_PROXY = "true";
          };
        };
      };

      services.nginx.virtualHosts = {
        "ntfy.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      systemd.tmpfiles.settings."ntfy-config" = {
        ${directories.config}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
        ${directories.cache}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
      };

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
          group = username;
        };
        groups.${username}.gid = ids.user.${username};
      };

      # containers.ntfy = {
      #   autoStart = true;
      #
      #   privateNetwork = true;
      #   hostAddress = "10.0.0.1";
      #   localAddress = localAddr;
      #
      #   privateUsers = "pick";
      #
      #   forwardPorts =
      #     map (p: {
      #       hostPort = p;
      #       protocol = "tcp";
      #     }) ports.tcp
      #     ++ map (p: {
      #       hostPort = p;
      #       protocol = "udp";
      #     }) ports.udp;
      #
      #   config =
      #     {
      #       config,
      #       pkgs,
      #       lib,
      #       ...
      #     }:
      #     {
      #       services.ntfy-sh = {
      #         enable = true;
      #
      #         settings = {
      #           listen-http = ":8082";
      #           base-url = "https://ntfy.home.lan";
      #           behind-proxy = true;
      #         };
      #       };
      #
      #       networking.firewall = {
      #         allowedTCPPorts = ports.tcp;
      #       };
      #
      #       networking.useHostResolvConf = lib.mkForce false;
      #       services.resolved.enable = true;
      #
      #       system.stateVersion = "26.05";
      #     };
      # };

    };
}
