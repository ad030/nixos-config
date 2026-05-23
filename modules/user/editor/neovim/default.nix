{ pkgs, ... }:

{
  # home.packages = [ pkgs.neovim ];
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = "vim.cmd.colorscheme = 'gruvbox'";
      }

      nvim-lspconfig
      comment-nvim

      lualine-nvim

      telescope-nvim

      conform-nvim

      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-c
        p.tree-sitter-python
        p.tree-sitter-json
      ]))

      vim-nix
    ];

    extraPackages = with pkgs; [
      xclip
      wl-clipboard

      luajitPackages.lua-lsp

      nixfmt
    ];
  };
}
