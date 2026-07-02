{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.server-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      rsync
      ethtool
      iperf3
    ];
  };
}
