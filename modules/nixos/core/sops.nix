{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sops =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        age
      ];

      sops.defaultSopsFile = "${self}/secrets/secrets.yaml";
      sops.defaultSopsFormat = "yaml";
    };
}
