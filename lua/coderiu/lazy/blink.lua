return {
    "saghen/blink.cmp",
    version = '1.*',
    dependencies = {
        "L3MON4D3/LuaSnip",
    },

    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'enter',
        },

        appearance = {
            nerd_font_variant = 'mono',
        },

        completion = {
            documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
            default = { 'lsp', 'path', 'snippets' },
        },

        snippets = { preset = 'luasnip' },

        fuzzy = { implementation = 'lua' },

        signature = { enabled = true },
    }
}
