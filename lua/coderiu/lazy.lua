local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ 'rose-pine/neovim' },
	
	{ 'folke/which-key.nvim' },

	{
		'windwp/nvim-autopairs',
		dependencies = { 'hrsh7th/nvim-cmp'},
	},
	
	{
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.2',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},

		},
	}
	
})
