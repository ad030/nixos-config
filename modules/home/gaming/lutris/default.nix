{
  self,
  inputs,
  ...
}:
{
  flake.modules.hm.lutris =
    { pkgs, ... }:
    {
      # programs.lutris = {
      #   enable = true;
      # };

      # temporary fix for lutris because openldap keeps failing
      # https://github.com/NixOS/nixpkgs/issues/513245#issuecomment-4319854191
      home.packages = [
        (pkgs.lutris.override {
          # Intercept buildFHSEnv to modify target packages
          buildFHSEnv =
            args:
            pkgs.buildFHSEnv (
              args
              // {
                multiPkgs =
                  envPkgs:
                  let
                    # Fetch original package list
                    originalPkgs = args.multiPkgs envPkgs;

                    # Disable tests for openldap
                    customLdap = envPkgs.openldap.overrideAttrs (_: {
                      doCheck = !envPkgs.stdenv.hostPlatform.isi686;
                    });
                  in
                  # Replace broken openldap with the custom one
                  builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
              }
            );
        })
      ];
    };
}
