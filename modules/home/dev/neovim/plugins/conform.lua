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
	},

	formatters_by_ft = {
		lua = { "stylua" },

		java = { "clang-format" },

		python = { "isort", "black" },

		css = { "prettierd" },

		html = { "prettierd" },
		yaml = { "prettierd" },

		javascript = { "deno_fmt" },
		typescript = { "deno_fmt" },
		json = { "deno_fmt" },
		markdown = { "deno_fmt" },

		csharp = { "clang-format" },

		c = { "clang-format" },

		cpp = { "clang-format" },

		sql = { "sleek" },

		tex = { "latexindent" },

		nix = { "nixfmt" },
	},
})
