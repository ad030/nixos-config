vim.pack.add({
	"https://github.com/nvim-mini/mini.ai",
	"https://github.com/nvim-mini/mini.completion",
	"https://github.com/nvim-mini/mini.icons",
	{
		src = "https://github.com/nvim-mini/mini.pick",
		version = "stable",
	},
	"https://github.com/nvim-mini/mini.snippets",
	"https://github.com/nvim-mini/mini.statusline",
	"https://github.com/nvim-mini/mini.surround",
})

require("mini.ai").setup({ n_lines = 500 })
require("mini.completion").setup()
require("mini.icons").setup()
require("mini.pick").setup()
require("mini.snippets").setup()
require("mini.statusline").setup({
	use_icons = vim.g.have_nerd_font,
	section_location = function()
		return "%2l:%-2v"
	end,
})
require("mini.surround").setup()
