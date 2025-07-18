require("coderiu.remap")
require("coderiu.lazy")
require("coderiu.set")
require("coderiu.plugin")

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function ()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

