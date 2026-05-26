{ pkgs, ... }:

{
  # home.packages = [ pkgs.neovim ];
  programs.neovim = {
    enable = true;

    withRuby = false;
    withPython3 = true;

    defaultEditor = true;

    initLua = ''
      ${builtins.readFile ./config/options.lua}
    '';

    extraPackages = with pkgs; [
      xclip
      wl-clipboard
      tree-sitter
      fd

      ## FORMATTERS AND LSPS
      luajitPackages.lua-lsp
      clang-tools
      nixfmt
      stylua
      black
      isort
      texlivePackages.latexindent
      prettierd
      pyright
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = "vim.cmd.colorscheme('gruvbox')";
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
        config = ''
          require("mini.statusline").setup({
          use_icons = vim.g.have_nerd_font,
          section_location = function()
                return "%2l:%-2v"
          end,
          })
        '';
      }

      nvim-treesitter.withAllGrammars

      vim-nix
    ];

  };
}
