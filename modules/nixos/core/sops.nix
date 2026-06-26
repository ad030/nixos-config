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
    let
      age-key-file = "/var/lib/sops-nix/key.txt";
    in
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
        age
      ];

      environment.sessionVariables = {
        SOPS_AGE_KEY_FILE = age-key-file;
      };

      sops.defaultSopsFile = "${self}/secrets/secrets.yaml";
      sops.defaultSopsFormat = "yaml";

      sops.age.keyFile = age-key-file;
      sops.age.generateKey = true;
    };
}
