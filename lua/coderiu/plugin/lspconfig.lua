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

local on_attach = function(client, bufnr)
	local opts = {buffer = bufnr}
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
	vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, opts)
	vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

	client.server_capabilities.semanticTokensProvider = nil
end

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

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end
}
