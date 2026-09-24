{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      ...
    }:
    {
      xdg.configFile."nvim" = {
        source = ./_config;
        recursive = true;
      };

      programs.neovim = {
        enable = true;
        withRuby = false;
        withPython3 = false;

        defaultEditor = true;

        extraPackages = with pkgs; [
          ## UTILITIES FOR PLUGINS
          xclip
          wl-clipboard
          tree-sitter
          fd
          ripgrep

          ## FORMATTERS AND LSPS
          lua-language-server
          luajitPackages.lua-lsp
          clang-tools
          nixfmt
          stylua
          black
          isort
          sleek
          deno
          texlivePackages.latexindent
          prettierd
          pyright
          typescript-language-server
          jdt-language-server
        ];

        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
        ];
      };
    };
}
