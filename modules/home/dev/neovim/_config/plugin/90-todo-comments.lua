-- highlight todo and other annotations in comments
vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
})

require("todo-comments").setup()
