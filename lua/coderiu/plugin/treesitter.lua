require('nvim-treesitter.configs').setup {
	ensure_installed = { 'c', 'vim', 'vimdoc', 'lua', 'rust', 'java'},
	sync_install = false,
	auto_install = false,
	highlight = { 
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	
}
