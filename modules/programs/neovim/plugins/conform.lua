require("conform").setup({
	notify_on_error = false,
	format_on_save = {
		timeout_ms = 750,
		lsp_fallback = true,
	},

	formatters = {
		["clang-format"] = {
			prepend_args = {
				"--style",
				[[{
                                                BasedOnStyle: LLVM,
                                                IndentWidth: 8,
                                                BreakBeforeBraces: Allman
                                        }]],
			},
		},
		-- ["sql_formatter"] = {
		--         prepend_args = {
		--                 "--config",
		--                 [[{
		--                                 "language": "sqlite",
		--                                 "tabWidth": 8,
		--                                 "keywordCase": "upper",
		--                                 "linesBetweenQueries": 2,
		--                                 "newlineBeforeSemicolon": true
		--                         }]],
		--         },
		-- },
		["latexindent"] = {
			prepend_args = {
				"-m",
			},
		},

		["prettierd"] = {
			env = {
				PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
					vim.fn.stdpath("config") .. "/utils/formatter-config/.prettierrc.json"
				),
			},
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },

		java = { "clang-format" },

		python = { "isort", "black" },

		javascript = { "prettierd" },

		typescript = { "prettierd" },

		css = { "prettierd" },

		html = { "prettierd" },

		json = { "prettierd" },

		yaml = { "prettierd" },

		markdown = { "prettierd" },

		csharp = { "clang-format" },

		c = { "clang-format" },

		-- sql = { "sleek" },

		tex = { "latexindent" },

		nix = { "nixfmt" },
	},
})
