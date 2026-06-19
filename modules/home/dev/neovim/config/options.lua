-- Set comma as the leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- no nerd font
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this oion if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
        tab = "» ",
        trail = "·",
        nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 4

-- 80 column border for good coding style
vim.opt.cc = "80"

-- set fast scrolling
vim.opt.ttyfast = true

-- bash-like tab completion
vim.opt.wildmode = "longest:list"

-- autoindent in c style
vim.opt.cindent = true

-- tabs are 8 spaces long
vim.opt.tabstop = 8
vim.opt.softtabstop = 8
-- indents are 8 spaces long
vim.opt.shiftwidth = 8

-- replace tabs with equivalent amount of spaces
vim.opt.expandtab = true

-- conceallevel
vim.opt.conceallevel = 0

-- use terminal colors
vim.opt.termguicolors = true

vim.opt.wrap = true

-- folding
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
