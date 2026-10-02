{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-freshrss =
    { config, lib, ... }:
    let
      directories = {
        data = "/srv/config/freshrss/data";
        extensions = "/srv/config/freshrss/extensions";
      };
      username = "freshrss";

      ids = {
        user = {
          ${username} = 2005;
        };
      };

      webPort = "8085";
    in
    {
      services.nginx.virtualHosts = {
        "freshrss.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
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

      systemd.tmpfiles.settings."freshrss-config" = {
        ${directories.data}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
        ${directories.extensions}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
      };

      sops.secrets."freshrss/env/ADMIN_PASSWORD" = { };
      sops.secrets."freshrss/env/ADMIN_API_PASSWORD" = { };

      sops.templates."freshrss.env".content = ''
        FRESHRSS_USER=--user admin --password ${
          config.sops.placeholder."freshrss/env/ADMIN_PASSWORD"
        } --api-password ${config.sops.placeholder."freshrss/env/ADMIN_API_PASSWORD"} --language en
      '';

      virtualisation.oci-containers.containers = {
        freshrss = {
          image = "docker.io/freshrss/freshrss:1.30.0@sha256:258b8edfc8a76a61f60d2d6a14d8f8d12495d78abf38646a2137612dfa264a21";
          hostname = "freshrss";
          # user = "${toString config.users.users.${username}.uid}:${
          #   toString config.users.groups.${username}.gid
          # }";
          ports = [
            "127.0.0.1:8085:80/tcp"
          ];
          volumes = [
            "${directories.data}:/var/www/FreshRSS/data"
            "${directories.extensions}:/var/www/FreshRSS/extensions"
          ];
          environmentFiles = [
            "${config.sops.templates."freshrss.env".path}"
          ];
          environment = {
            TZ = "America/New_York";
            CRON_MIN = "1,31";
            FRESHRSS_INSTALL = ''
              --api-enabled
              --base-url http://freshrss.home.lan
              --default-user admin
              --language en
            '';
            TRUSTED_PROXY = "10.88.0.0/16";
          };
        };
      };

      # containers.freshrss = {
      #   autoStart = true;
      #
      #   privateNetwork = true;
      #   hostAddress = "10.0.0.1";
      #   localAddress = localAddr;
      #
      #   privateUsers = "pick";
      #
      #   # pass in sops secrets into container using systemd loadcredentials
      #   # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
      #   extraFlags = [
      #     "--load-credential=freshrss-password:${config.sops.secrets."freshrss/password".path}"
      #   ];
      #
      #   forwardPorts = [
      #     {
      #       hostPort = 8080;
      #       containerPort = 80;
      #       protocol = "tcp";
      #     }
      #   ];
      #
      #   config =
      #     {
      #       config,
      #       pkgs,
      #       lib,
      #       ...
      #     }:
      #     {
      #       services.freshrss = {
      #         enable = true;
      #
      #         baseUrl = "http://freshrss.home.lan";
      #
      #         defaultUser = "dokja";
      #         passwordFile = "/run/credentials/@system/freshrss-password";
      #       };
      #
      #       networking.firewall = {
      #         allowedTCPPorts = [ 80 ];
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
