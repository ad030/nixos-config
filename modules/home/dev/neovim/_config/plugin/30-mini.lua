vim.pack.add({
	{
		src = "https://github.com/nvim-mini/mini.nvim",
		version = "stable",
	},
})

require("mini.ai").setup({ n_lines = 500 })
require("mini.completion").setup()
require("mini.cmdline").setup({
	autocomplete = {
		enable = false,
	},
})
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
