{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-qbittorrent =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "qbittorrent";

      ids = {
        group = {
          media = 3333;
        };
        user = {
          ${username} = 2007;
        };
      };

      directories = {
        incompleteDownloads = "/srv/downloads/qbittorrent";
        completeDownloads = "/srv/media/tank/Downloads/qbittorrent";
        config = "/srv/config/qbittorrent";
      };

      webPort = "8090";

    in
    {
      virtualisation.oci-containers.containers = {
        qbittorrent = {
          image = "docker.io/qbittorrentofficial/qbittorrent-nox:5.2.4-1@sha256:92bfd78d731e254ba64f62b77b0696add6447a33642ee5feda106a26b285aa7f";
          hostname = "qbittorrent";
          volumes = [
            "${directories.config}:/config"
            "${directories.completeDownloads}:/downloads/complete"
            "${directories.incompleteDownloads}:/downloads/incomplete"
          ];
          ports = [
            "6881:6881/tcp"
            "6881:6881/udp"
            "127.0.0.1:8090:8090/tcp"
          ];
          environment = {
            PUID = "${toString config.users.users.${username}.uid}";
            PGID = "${toString config.users.groups.${username}.gid}";
            PAGID = "${toString config.users.groups.media.gid}";
            QBT_LEGAL_NOTICE = "confirm";
            QBT_TORRENTING_PORT = "6881";
            QBT_WEBUI_PORT = "8090";
            TZ = "America/New_York";
          };
        };
      };

      systemd.tmpfiles.settings."qbittorrent-config" = {
        ${directories.incompleteDownloads}.d = {
          user = username;
          group = "media";
          mode = "2775";
        };
        ${directories.completeDownloads}.d = {
          user = username;
          group = "media";
          mode = "2775";
        };
        ${directories.config}.d = {
          user = username;
          group = username;
          mode = "0700";
        };
      };

      services.nginx.virtualHosts = {
        "qbittorrent.home.lan" = {
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

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
        };
        groups.${username}.gid = ids.user.${username};
      };

      # services.qbittorrent = {
      #   enable = true;
      #   package = pkgs.qbittorrent-nox;
      #
      #   user = "qbittorrent";
      #   group = "media";
      #
      #   openFirewall = true;
      #
      #   torrentingPort = 6881;
      #   webuiPort = 8090;
      #
      #   profileDir = directories.config;
      #
      #   serverConfig = {
      #     BitTorrent = {
      #       Session = {
      #         GlobalUPSpeedLimit = "20";
      #         DefaultSavePath = directories.completeDownloads;
      #         TempPath = directories.incompleteDownloads;
      #         TempPathEnabled = "true";
      #       };
      #     };
      #     Preferences = {
      #       WebUI = {
      #         Password_PBKDF2 = "@ByteArray(1f+GZ4bqvo93Lgp/d3//FA==:Thyh7U5F+vC3d7VEQ/aIwShyzg6ssb/2Qy4JwD5dM4ycyFLDK5Nu/DxScj2R7u56q36jLxCd1vn7ql5iThHzvA==)";
      #         ReverseProxySupportEnabled = "true";
      #         TrustedReverseProxiesList = "10.88.0.0/16";
      #         ServerDomains = "qbittorrent.home.lan";
      #         CSRFProtection = "false";
      #       };
      #     };
      #   };
      # };

      ## this didn't work except it did work only after i commented it out somehow so i have no clue what is going on
      ## put this in let ... in block, run nixos-rebuild test, then comment it out and do it again
      ## https://github.com/NixOS/nixpkgs/blob/1ec21f6ee4970c41e0824c539c52a50e91fab898/nixos/modules/services/torrent/qbittorrent.nix
      # inherit (builtins) concatStringsSep isAttrs isString;
      # inherit (lib)
      #   mapAttrsRecursive
      #   collect
      #   escape
      #   replaceString
      #   ;
      # inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
      # gendeepINI = toINI {
      #   mkKeyValue =
      #     let
      #       sep = "=";
      #     in
      #     k: v:
      #     if isAttrs v then
      #       concatStringsSep "\n" (
      #         collect isString (
      #           mapAttrsRecursive (
      #             path: value:
      #             "${escape [ sep ] (concatStringsSep "\\" ([ k ] ++ path))}${sep}${
      #               replaceString "\n" "\\n" (mkValueStringDefault { } value)
      #             }"
      #           ) v
      #         )
      #       )
      #     else
      #       mkKeyValueDefault { } sep k v;
      # };
      # configFile = pkgs.writeText "qBittorrent.conf" (gendeepINI {
      #   BitTorrent = {
      #     Session = {
      #       GlobalUPSpeedLimit = "20";
      #       DefaultSavePath = "/downloads/complete";
      #       TempPath = "/downloads/incomplete";
      #       TempPathEnabled = "true";
      #     };
      #   };
      #   Preferences = {
      #     WebUI = {
      #       Password_PBKDF2 = "@ByteArray(1f+GZ4bqvo93Lgp/d3//FA==:Thyh7U5F+vC3d7VEQ/aIwShyzg6ssb/2Qy4JwD5dM4ycyFLDK5Nu/DxScj2R7u56q36jLxCd1vn7ql5iThHzvA==)";
      #       ReverseProxySupportEnabled = "true";
      #       TrustedReverseProxiesList = "10.88.0.0/16";
      #       ServerDomains = "qbittorrent.home.lan";
      #       CSRFProtection = "false";
      #     };
      #   };
      # });
      # containers.qbittorrent = {
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
      #   # no id map option yet, workaround
      #   # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
      #   bindMounts = {
      #     "/downloads/incomplete" = {
      #       mountPoint = "/downloads/incomplete:idmap";
      #       hostPath = "${incompleteDir}/qbittorrent";
      #       isReadOnly = false;
      #     };
      #     "/downloads/complete" = {
      #       mountPoint = "/downloads/complete:idmap";
      #       hostPath = "${completeDir}/qbittorrent";
      #       isReadOnly = false;
      #     };
      #   };
      #
      #   config =
      #     {
      #       config,
      #       pkgs,
      #       lib,
      #       ...
      #     }:
      #     {
      #       users.groups.media.gid = mediaGid;
      #
      #       services.qbittorrent = {
      #         enable = true;
      #         package = pkgs.qbittorrent-nox;
      #
      #         group = "media";
      #
      #         torrentingPort = 6881;
      #         webuiPort = 8090;
      #
      #         serverConfig = {
      #           BitTorrent = {
      #             Session = {
      #               GlobalUPSpeedLimit = "20";
      #               DefaultSavePath = "/downloads/complete";
      #               TempPath = "/downloads/incomplete";
      #               TempPathEnabled = "true";
      #             };
      #           };
      #           Preferences = {
      #             WebUI = {
      #               Password_PBKDF2 = "@ByteArray(1f+GZ4bqvo93Lgp/d3//FA==:Thyh7U5F+vC3d7VEQ/aIwShyzg6ssb/2Qy4JwD5dM4ycyFLDK5Nu/DxScj2R7u56q36jLxCd1vn7ql5iThHzvA==)";
      #               ReverseProxySupportEnabled = "true";
      #               TrustedReverseProxiesList = "10.0.0.1";
      #               ServerDomains = "qbittorrent.home.lan";
      #               CSRFProtection = "false";
      #             };
      #           };
      #         };
      #       };
      #
      #       networking.firewall = {
      #         allowedTCPPorts = ports.tcp;
      #         allowedUDPPorts = ports.udp;
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
