-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>lq', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>lQ', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>lc', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

if pcall(require, 'which-key')
then
	local wk = require("which-key")
	wk.register({
		D = 'lsp declartion',
		d = 'lsp definition',
		i = 'lsp implementation',
		r = 'lsp references',
		t = "type definition",
	}, { mode = "n", prefix = "g" })

	wk.register({
		l = { name = "Lsp",
			w = { name = "Worksapce",
				a = "add folder",
				r = "remove folder",
				l = "list folder"
			},
			r = "rename",
			c = "code action",
			f = "formatting",
			Q = "diagnostic lists",
			q = "diagnostic float",
		}
	}, { mode = "n", prefix = "<leader>" })

	wk.register({
		l = { name = "Lsp",
			c = "code action",
			f = "formatting",
		},
	}, { mode = "v", prefix = "<leader>" })
end

vim.diagnostic.config({
	signs = true,
	underline = false,
	update_in_insert = false,
	virtual_text = false,
})

vim.keymap.set("v", "<leader>lf", vim.lsp.buf.format, { remap = false })
