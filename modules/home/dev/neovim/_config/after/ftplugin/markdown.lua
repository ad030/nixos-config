vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	-- "https://github.com/epwalsh/obsidian.nvim",
})

vim.opt_local.conceallevel = 1

require("render-markdown").setup({})
