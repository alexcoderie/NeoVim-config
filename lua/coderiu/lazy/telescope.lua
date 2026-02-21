return {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
       { 'nvim-telescope/telescope-ui-select.nvim' },
       { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },

    config = function ()
        require('telescope').setup {
            defaults = {},
            pickers = {
                find_files = {
                    disable_devicons = false
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }
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
    end
}
