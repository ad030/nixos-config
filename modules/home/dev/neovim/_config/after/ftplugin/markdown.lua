vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	{
		src = "https://github.com/obsidian-nvim/obsidian.nvim",
		version = vim.version.range("*"), -- latest release
	},
})

vim.opt_local.conceallevel = 1

require("render-markdown").setup({})

local obsidian = require("obsidian")

obsidian.setup({
	workspaces = {
		{
			name = "personal",
			path = "~/Vaults/personal-notes",
		},
	},

	notes_subdir = "000_inbox",
	new_notes_location = "notes_subdir",

	daily_notes = {
		folder = "000_inbox",
		date_format = "%Y-%m-%d",
		default_tags = { "daily" },
	},

	templates = {
		folder = "800_templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},

	attachments = {
		img_folder = "900_assets",
	},

	mappings = {
		-- [G]oto [F]ile in obsidian vault
		["gf"] = {
			action = function()
				return obsidian.util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		-- Toggle check-boxes.
		["<leader>ch"] = {
			action = function()
				return obsidian.util.toggle_checkbox()
			end,
			opts = { buffer = true, desc = "Obsidian: Toggle [ch]eckbox" },
		},
		-- smart action; toggle checkbox or follow link
		["<cr>"] = {
			action = function()
				return obsidian.util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
		-- open daily note
		["<leader>Od"] = {
			action = function()
				return obsidian.client.today()
			end,
			opts = { buffer = true, expr = true, desc = "[O]bsidian: Open [D]aily Note" },
		},
		-- open new note
		["<leader>On"] = {
			action = function()
				return obsidian.client.today()
			end,
			opts = { buffer = true, expr = true, desc = "[O]bsidian: Open [N]ew Note" },
		},
	},

	completion = {
		nvim_cmp = false,
	},

	picker = {
		name = "mini.pick",
	},
})
