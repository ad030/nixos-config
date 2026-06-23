{
  flake.modules.nixos.idle-lock = {
    security.pam.services = {
      hyprlock = { };
    };
  };
}
