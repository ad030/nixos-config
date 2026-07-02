{ self, inputs, ... }:
{
  flake.modules.homeManager.audio = {
    # easyeffects audio equalizer
    services.easyeffects = {
      enable = true;
    };
  };
}
