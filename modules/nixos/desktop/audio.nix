{ self, flakes, ... }:
{
  flake.modules.nixos.audio = {
    services = {
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    # needed for easyeffects
    programs.dconf.enable = true;
  };
}
