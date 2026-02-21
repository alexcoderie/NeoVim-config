return {
	"nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'rose-pine',
                component_separators = '|',
                section_separators = '',
            },
        })
    end
}
