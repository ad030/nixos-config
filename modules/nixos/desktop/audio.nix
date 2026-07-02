{ self, flakes, ... }:
{
  flake.modules.nixos.audio = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # audio
      pavucontrol
      pamixer
      wireplumber

    ];

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
