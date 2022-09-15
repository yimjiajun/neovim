 vim.api.nvim_set_option('completeopt', 'menu,menuone,noselect')
  -- Set up nvim-cmp.
-- local tabnine = require "cmp_tabnine"
--
-- tabnine:setup {
--   max_lines = 100,
--   max_num_results = 5,
--   sort = true,
-- }

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
require "cmp_nvim_lsp"
require "cmp_buffer"
require "cmp_nvim_lsp"
require "cmp_nvim_lua"
require "cmp_calc"
require "cmp_emoji"

local cmp = require'cmp'

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
    formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				path = "[Path]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				calc = "[Calc]",
				emoji = "[Emoji]",
				ultisnips = "[UltiSnips]",
				cmp_tabnine = "[TabNine]",
			})[entry.source.name]

			return vim_item
		end,
	},
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		{ name = "buffer" },
		{ name = "cmp_tabnine" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "calc" },
		{ name = "emoji" }, -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
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
local servers = { 'bashls', 'clangd', 'cmake',
		'sumneko_lua', 'zk', 'ltex', 'yamlls',
		'powershell_es', 'pyright'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
  }
end
