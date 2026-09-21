vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
})

require("plenary")
require("nvim-treesitter").setup()
