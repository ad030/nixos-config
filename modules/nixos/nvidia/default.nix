{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.nvidia =
    {
      pkgs,
      config,
    }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];
      environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
      programs.sway.package = pkgs.sway.override { extraOptions = [ "--unsupported-gpu" ]; };
    };
}
