vim.api.nvim_set_option('completeopt', 'menu,menuone,noselect')

local cmp = require("cmp")
local lspkind = {}

if pcall(require, 'lspkind') then
	lspkind = require('lspkind')
end

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'calc' },
		{ name = 'emoji' },
		{ name = 'nvim_lua' },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = 'text', -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function (entry, vim_item)
				return vim_item
			end
		})
	}
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }--
local lspconfig = require('lspconfig')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>le', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>lq', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-l>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>lwl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>lc', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>lf', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- TODO this should change with mason.lua ( require("mason-lspconfig").setup({...)
local servers = { 'bashls', 'cmake',
'lua_ls', 'zk', 'yamlls',
'powershell_es', 'pyright', 'pylsp'}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
		on_attach = on_attach,
		flags = lsp_flags,
	}
end

require('lspconfig')['lua_ls'].setup{
	settings = {
		Lua = {
			diagnostics = {
				-- ignore undefined global vim.x.xx
				globals = { 'vim' }
			}
		}
	},
}

local clangd_capabilities = capabilities
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = "utf-8"
require('lspconfig')['clangd'].setup{
	capabilities = clangd_capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		"--clang-tidy",
		"--suggest-missing-includes",
		"--cross-file-rename",
		"--completion-style=detailed",
	},
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
		semanticHighlighting = true,
	},
	on_attach = on_attach,
	flags = lsp_flags,
}

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
vim.lsp.handlers.hover, {
	border = _border
}
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
vim.lsp.handlers.signature_help, {
	border = _border
}
)

vim.diagnostic.config{
	float={border=_border}
}

if pcall(require, "which-key") then
	local wk = require("which-key")

	wk.register({
		l = { name = "Lsp",
		e = "diagnostic open float",
		q = "diagnostic setloclist",
		w = { name = "workspace folder",
		a = "add",
		r = "remove",
		l = "list",
	},
	r = "rename buffer",
	c = "code action",
	f = "formatting",
},
	}, { mode = 'n',  prefix = "<leader>" })

	wk.register({
		d = "lsp next diagnostic",
		D = "lsp previous diagnostic",
	}, { mode = 'n',  prefix = "]" })

	wk.register({
		r = "lsp reference",
		D = "lsp decalaration",
		d = "lsp definition",
		i = "lsp implementation",
		y = "lsp type-definition",
	}, { mode = 'n',  prefix = "g" })
end
