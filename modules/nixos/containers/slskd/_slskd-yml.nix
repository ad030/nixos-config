# generate declarative slskd config
{ pkgs, domain, ... }:
let
  settingsFormat = pkgs.formats.yaml { };
in
settingsFormat.generate "slskd.yml" {
  # anti leecher stuff
  transfers = {
    groups = {
      # https://www.reddit.com/r/Soulseek/comments/1xnitxf/comment/19s6qt1xxb63l
      leechers = {
        thresholds = {
          files = 1;
          directories = 1;
        };
        upload = {
          priority = 999;
          strategy = "roundrobin";
          slots = 1;
          speed_limit = 50;
        };
      };
      # https://www.reddit.com/r/Soulseek/comments/1xnitxf/comment/19s4t8d0km5cw
      blacklisted = {
        patterns = [
          "^u[0-9a-f]{12}$"
        ];
      };
    };
  };
  # need to do this in order to set up webhooks declaratively
  # following the nixpkgs config
  # https://github.com/nixos/nixpkgs/blob/master/nixos/modules/services/web-apps/slskd.nix
  integrations = {
    webhooks = {
      message_webhook = {
        on = [ "PrivateMessageReceived" ];
        call = {
          url = "https://ntfy.${domain}/slskd-message";
          headers = [
            {
              name = "Title";
              value = "slskd: New message";
            }
            {
              name = "Priority";
              value = "default";
            }
          ];
          ignore_certificate_errors = true;
        };
      };
    };
  };
}
