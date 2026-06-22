# use gnome keyring for secrets backend
{ self, inputs, ... }:
{
  flake.modules.nixos.secrets =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
    };
}
