{
  flake.modules.homeManager.neovim =

    { pkgs, ... }:

    {
      home.packages = with pkgs; [
        deno
        ripgrep
      ];

      programs.neovim = {
        enable = true;
        withRuby = false;
        withPython3 = true;

        defaultEditor = true;

        initLua = ''
          ${builtins.readFile ./config/options.lua}
        '';

        extraPackages = with pkgs; [
          ## UTILITIES FOR PLUGINS
          xclip
          wl-clipboard
          tree-sitter
          fd

          ## FORMATTERS AND LSPS
          lua-language-server
          luajitPackages.lua-lsp
          clang-tools
          nixfmt
          stylua
          black
          isort
          sleek
          texlivePackages.latexindent
          prettierd
          pyright
          typescript-language-server
        ];

        plugins = with pkgs.vimPlugins; [
          {
            plugin = gruvbox-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/gruvbox.lua;
          }

          which-key-nvim

          todo-comments-nvim

          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = builtins.readFile ./plugins/lspconfig.lua;
          }

          comment-nvim

          lualine-nvim

          {
            plugin = oil-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/oil.lua;
          }

          {
            plugin = telescope-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/telescope.lua;
          }

          {
            plugin = conform-nvim;
            type = "lua";
            config = builtins.readFile ./plugins/conform.lua;
          }

          mini-icons
          mini-surround
          mini-snippets
          mini-completion

          {
            plugin = mini-ai;
            type = "lua";
            config = ''require("mini.ai").setup({ n_lines = 500})'';
          }

          {
            plugin = mini-statusline;
            type = "lua";
            config = builtins.readFile ./plugins/vimtex.lua;
          }

          nvim-treesitter.withAllGrammars

          vim-nix

          {
            plugin = vimtex;
            type = "lua";
            config = builtins.readFile ./plugins/vimtex.lua;
          }

          render-markdown-nvim
        ];

      };
    };
}
