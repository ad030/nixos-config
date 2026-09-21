vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(opts)
		vim.opt.conceallevel = 1
		vim.opt.colorcolumn = ""
	end,
})
