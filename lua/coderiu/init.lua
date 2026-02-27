require("coderiu.remap")
require("coderiu.set")
require("coderiu.lazy_init")
require("coderiu.current-colorscheme")

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function ()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

