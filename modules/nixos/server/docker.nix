{
  flake.modules.nixos.docker =
    {
      config,
      pkgs,
      ...
    }:
    {
      # TODO: think about what to do for server applications
      # do i want to use docker compose as i already have been
      # or use native packages in nixpkgs
    };
}
