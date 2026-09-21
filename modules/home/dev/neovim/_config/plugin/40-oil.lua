-- buffer file browser
vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})

local oil = require("oil")

oil.setup()

-- keymaps
vim.keymap.set("n", "<leader>oo", function()
	oil.open()
end, { desc = "Open oil browser in parent directory" })
