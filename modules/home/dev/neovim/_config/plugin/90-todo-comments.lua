-- highlight todo and other annotations in comments
vim.pack.add({
	src = "https://github.com/folke/todo-comments.nvim",
})

require("todo-comments").setup()
