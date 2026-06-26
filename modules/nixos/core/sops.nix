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
        sops
        age
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";

        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
}
