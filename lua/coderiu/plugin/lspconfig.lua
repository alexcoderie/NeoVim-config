local lspconfig = require('lspconfig');

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<CR>'] = cmp.mapping.confirm({ select = true}),
	},

	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}

-- local on_attach = function(client, bufnr)
-- 	local opts = {buffer = bufnr}
-- 	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
-- 	vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
-- 	vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, opts)
-- 	vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
-- 	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--
-- 	client.server_capabilities.semanticTokensProvider = nil
-- end

local servers = {
	lua_ls = {
		Lua = {
			workspace = {checkThirdParty = false},
			telemetry = {enable = false},
		},
	},
}

require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require 'mason-lspconfig'

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event, bufnr)
        local opts = {buffer = bufnr}
        
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
        vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, opts)
        vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
        end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
        end
    end
})

vim.diagnostic.config {
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
}

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
            }
        end
    }
}

-- mason_lspconfig.setup_handlers {
-- 	function(server_name)
-- 		require('lspconfig')[server_name].setup {
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 			settings = servers[server_name],
-- 			filetypes = (servers[server_name] or {}).filetypes,
-- 		}
-- 	end
-- }
