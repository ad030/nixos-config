{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "qbittorrent";
  uid = 2007;

  image = "lscr.io/linuxserver/qbittorrent";
  tag = "5.3.0";
  digest = "sha256:75ecbb1c89ab7b0a21c4bde40b4820e4f1649d2d56d83b91913422155e8d2a5f";

  domain = "4384381.xyz";
  subdomain = "qbittorrent.${domain}";
  webPort = "8090";

  directories = {
    downloadsIncomplete = "/srv/downloads/qbittorrent";
    downloadsComplete = "/srv/media/tank/Downloads/qbittorrent/media";
    backupsTorrent = "/srv/backup/qbittorrent/torrent-files";
  };
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      auth = top.config.flake.lib.nginx-tinyauth;
    in
    {
      imports = with top.config.flake.modules.nixos; [
        containers
      ];

      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
          extraGroups = [
            "media"
          ];
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      systemd.tmpfiles.settings."qbittorrent-config" = {
        ${directories.downloadsIncomplete}.d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
        ${directories.downloadsComplete}.d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
        ${directories.backupsTorrent}.d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${webPort}";
              recommendedProxySettings = true;
              # extraConfig = auth.appendProtect "";
            };
            # "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      networking.firewall = {
        allowedTCPPorts = [
          8090
        ];
      };
    };

  flake.modules.homeManager."containers-${serviceName}" =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    {
      home.username = serviceName;
      home.homeDirectory = "/home/${serviceName}";
      home.stateVersion = "26.05";

      # generate xdg directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          ${serviceName} = {
            image = "${image}:${tag}@${digest}";
            userNS = "keep-id";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config"

              "${directories.downloadsComplete}:/downloads/complete"
              "${directories.downloadsIncomplete}:/downloads/incomplete"
              "${directories.backupsTorrent}:/torrent-files"
            ];
            ports = [
              # "127.0.0.1:${webPort}:${webPort}/tcp"
              "${webPort}:${webPort}/tcp"

              "6881:6881/tcp"
              "6881:6881/udp"
            ];
            environment = {
              PUID = "${toString osConfig.users.users.${serviceName}.uid}";
              PGID = "${toString osConfig.users.groups.media.gid}";
              # LEGAL_NOTICE = "confirm";
              TORRENTING_PORT = "6881";
              WEBUI_PORT = webPort;
              TZ = "America/New_York";
            };
            autoStart = true;
          };
        };
      };
    };
}
