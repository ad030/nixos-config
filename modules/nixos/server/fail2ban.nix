{
  flake.modules.nixos.fail2ban = {
    services.fail2ban = {
      enable = true;

      bantime = "1h";
      bantime-increment = {
        enable = true;
        maxtime = "168h";
        rndtime = "8m";
      };

      # don't ban myself
      ignoreIP = [
        "127.0.0.1/8"
        "192.168.0.0/16"
        "10.0.0.0/8"
      ];

      jails = {
        nginx-botsearch.settings = {
          enabled = true;
          filter = "nginx-botsearch";
          logpath = "/var/log/nginx/access.log";
          backend = "auto";
          maxretry = 5;
          findtime = "10m";
        };

        nginx-bad-request.settings = {
          enabled = true;
          filter = "nginx-bad-request";
          logpath = "/var/log/nginx/access.log";
          backend = "auto";
          maxretry = 10;
          findtime = "10m";
        };

        # failed tinyauth logins
        tinyauth = {
          settings = {
            enabled = true;
            logpath = "/var/log/nginx/access.log";
            backend = "auto";
            maxretry = 5;
            findtime = "10m";
          };
          filter.Definition = {
            failregex = ''^<HOST> .* "POST /api/user/login[^"]*" (401|403) '';
            ignoreregex = "";
          };
        };
      };
    };
  };
}
