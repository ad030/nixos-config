{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.landing-page =
    {
      config,
      lib,
      ...
    }:
    {
      environment.etc = {
        "www/index.html" = {
          text = builtins.readFile ./index.html;
        };
      };

      services.nginx.virtualHosts = {
        "home.lan" = {
          root = "/etc/www";

          locations."/".index = "index.html";
        };
      };

    };
}
