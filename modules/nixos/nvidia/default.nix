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
      ...
    }:
    {
      boot.initrd.availableKernelModules = [
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia"
      ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      services.xserver.videoDrivers = [ "nvidia" ];
      environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];

      hardware.graphics.enable = true;

      hardware.nvidia = {
        # kernel modesetting needed for wayland
        modesetting.enable = true;
        # false = use open drivers from nvidia (not nouveau)
        open = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

      };

      programs.sway.package = pkgs.sway.override { extraOptions = [ "--unsupported-gpu" ]; };

    };
}
