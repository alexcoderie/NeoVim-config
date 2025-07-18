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

	--Theme
	{ 'rose-pine/neovim' },

    --Icons    
    {'nvim-tree/nvim-web-devicons'},

	--Lua line
	{ 'nvim-lualine/lualine.nvim' },

	--Show keybindings
	{ 'folke/which-key.nvim' },

	--Autopairs
	{
		'windwp/nvim-autopairs',
		dependencies = { 'hrsh7th/nvim-cmp'},
	},

	--Telescope + fuzzy finder
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
	},

	--Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate'
	},

	--LSP
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'mason-org/mason.nvim', config = true },
			'mason-org/mason-lspconfig.nvim',
			{ 'j-hui/fidget.nvim', opts = {} },
			'folke/neodev.nvim',
		},
	},

	--Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{'L3MON4D3/LuaSnip', build = "make install_jsregexp"},
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'rafamadriz/friendly-snippets',

		},
    },

	--Fugitive (pentru git tati)
	{ 'tpope/vim-fugitive' },

	--Harpoon
	{ 'theprimeagen/harpoon' },

	--Undotree
	{ 'mbbill/undotree' },

	--Comment
	{ 'numToStr/Comment.nvim', opts = {} },

    --Indent blankline
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }
})
