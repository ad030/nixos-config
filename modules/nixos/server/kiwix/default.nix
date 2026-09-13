{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.kiwix-serve =
    { config, lib, ... }:
    let
      localAddr = "10.0.0.19";
      webPort = "8084";

      zimFilesDir = "/srv/media/tank/zim_files";
    in
    {
      services.nginx.virtualHosts = {
        "kiwix.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      containers.kiwix-serve = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

        privateUsers = "pick";

        forwardPorts = [
          {
            hostPort = 8084;
            containerPort = 8084;
            protocol = "tcp";
          }
        ];

        bindMounts = {
          "/zim" = {
            mountPoint = "/zim";
            hostPath = zimFilesDir;
            isReadOnly = true;
          };
        };

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            services.kiwix-serve = {
              enable = true;

              port = 8084;
              openFirewall = true;

              library =
                # all files live in /zim directory
                # remember to add leading slash
                builtins.mapAttrs (_: f: "/zim${f}") {
                  archWiki = "/archlinux_en_all_maxi_2026-07.zim";
                  cDocs = "/devdocs_en_c_2026-07.zim";
                  nixDocs = "/devdocs_en_nix_2026-07.zim";
                  explainXkcd = "/explainxkcd_en_all_maxi_2026-07.zim";
                  gentooWiki = "/gentoo_en_all_maxi_2026-07.zim";
                  wikipediaCS = "/wikipedia_en_computer_maxi_2026-06.zim";
                  wikipediaKnots = "/wikipedia_en_knots_maxi_2026-07.zim";
                  wikipediaMath = "/wikipedia_en_mathematics_maxi_2026-06.zim";
                };
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}
