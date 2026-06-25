{ self, inputs, ... }:
{
  flake.modules.nixos.secret-service =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      # use gnome keyring for secrets backend
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
    };
}
