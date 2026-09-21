vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
})

require("gruvbox").setup({
	terminal_colors = true,
	transparent_mode = false,
})

vim.cmd.colorscheme("gruvbox")
