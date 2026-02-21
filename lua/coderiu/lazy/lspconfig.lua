return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "stevearc/conform.nvim",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "saghen/blink.cmp",
        "L3MON4D3/LuaSnip",
        "j-hui/fidget.nvim",
        "folke/neodev.nvim",
        "folke/lazydev.nvim",
    },

    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        local servers = {
            lua_ls = {
                Lua = {
                    workspace = {checkThirdParty = false},
                    telemetry = {enable = false},
                },
            },
        }

        require("fidget").setup({})
        require("mason").setup()
        require("neodev").setup()
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    }
                end
            }
        })

        vim.diagnostic.config({
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
              text = {
                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                [vim.diagnostic.severity.WARN] = '󰀪 ',
                [vim.diagnostic.severity.INFO] = '󰋽 ',
                [vim.diagnostic.severity.HINT] = '󰌶 ',
              },
            } or {},
            virtual_text = {
              source = 'if_many',
              spacing = 2,
              format = function(diagnostic)
                local diagnostic_message = {
                  [vim.diagnostic.severity.ERROR] = diagnostic.message,
                  [vim.diagnostic.severity.WARN] = diagnostic.message,
                  [vim.diagnostic.severity.INFO] = diagnostic.message,
                  [vim.diagnostic.severity.HINT] = diagnostic.message,
                }
                return diagnostic_message[diagnostic.severity]
              end,
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event, bufnr)
                local opts = {buffer = bufnr}

                vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'grr', require('telescope.builtin').lsp_references, opts)
                vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, opts)
                vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method('textDocument/documentHighlight', event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },{
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                      buffer = event.buf,
                      group = highlight_augroup,
                      callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                      callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                      end,
                    })
                end
            end
        })
    end,
}

