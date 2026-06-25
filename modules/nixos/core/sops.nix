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
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        age
      ];

      sops.defaultSopsFile = "${self}/secrets/secrets.yaml";
      sops.defaultSopsFormat = "yaml";

      sops.age.keyFile = "/var/lib/sops-nix/key.txt";
      sops.age.generateKey = true;
    };
}
