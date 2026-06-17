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
      # environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
      hardware.graphics.enable = true;
      hardware.nvidia.open = true;
      programs.sway.package = pkgs.sway.override { extraOptions = [ "--unsupported-gpu" ]; };
    };
}
