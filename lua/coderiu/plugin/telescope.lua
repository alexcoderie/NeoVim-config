require('telescope').setup { defaults = {}, pickers = { find_files = { disable_devicons = false },}, }
pcall(require('telescope').load_extension, 'fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {desc = '[S]earch [F]iles'})
vim.keymap.set('n', '<leader>?', builtin.oldfiles, {desc = '[?] Find recently opened files'})
vim.keymap.set('n', '<leader>/',function()
	builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, {desc = '[/] Fuzzily search in current buffer'})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {desc = '[P]roject [S]earch'})
vim.keymap.set('n', '<leader>sg', builtin.git_files, {desc = '[S]earch [G]it files'})
