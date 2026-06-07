{
  flake.modules.homeManager.vicinae =
    {
      self,
      pkgs,
      inputs,
      ...
    }:

    {
      services.vicinae = {
        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        settings = {
          close_on_focus_loss = true;
          consider_preedit = true;
          pop_to_root_on_close = true;
          favicon_service = "twenty";
          search_files_in_root = false;
          telemetry = false;

          font = {
            normal = {
              size = 14;
              family = "MesloLGM Nerd Font";
            };
          };

          theme = {
            light = {
              name = "gruvbox-light";
              icon_theme = "default";
            };
            dark = {
              name = "gruvbox-dark";
              icon_theme = "default";
            };
          };

          launcher_window = {
            opacity = 1.00;
          };
        };

        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          bluetooth
          nix
          power-profile
          # Extension names can be found in the link below, it's just the folder names
        ];
      };
    };
}
