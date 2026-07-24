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
        "nvidia_uvm"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia"
      ];

      boot.kernelParams = [
        "nvidia-drm.modeset=1"
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

        # true: use open drivers from nvidia (not nouveau)
        # false: use proprietary drivers from nvidia
        open = true;

        powerManagement.enable = true;
        powerManagement.finegrained = false;

      };

      programs.sway.package = pkgs.sway.override { extraOptions = [ "--unsupported-gpu" ]; };

    };
}
