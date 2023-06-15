local function setup_key_tabular()
	if pcall(require, "tabular") == 0 then
		return
	end

	function Tabular_align()
		local delimiter = vim.fn.input('Enter delimiter: ')
		vim.cmd('Tabularize /' .. delimiter)
	end

	vim.api.nvim_set_keymap('n', '<Leader>gt', [[<cmd> lua Tabular_align() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('v', '<Leader>gt', [[<cmd> lua Tabular_align() <CR>]], { silent = true })
	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ t = "TableMode" }, { mode ='n', prefix = "<leader>g" })
		wk.register({ t = "TableMode" }, { mode ='v', prefix = "<leader>g" })
	end
end

local function autocmd_vim_table_mode()
	if pcall(require, "vim-table-mode") == 0 then
		return
	end

	vim.api.nvim_exec([[
	augroup vim-markdown-plugin
	autocmd!
	autocmd FileType markdown,org let g:table_mode_corner='|' | execute 'TableModeEnable'
	augroup END
	]], false)
end

local function setup_key_vim_table_mode()
	if pcall(require, "vim-table-mode") == 0 then
		return
	end

	vim.api.nvim_create_augroup( "vim-markdown-plugin", { clear = true })
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "Setup keymapping for markdown table",
		group = "vim-markdown-plugin",
		pattern = "markdown",
		callback = function()
			vim.api.nvim_set_keymap('n', '<leader>gTt', [[<cmd> TableModeToggle <CR>]], { silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gTe', [[<cmd> TableEvalFormulaLine <CR>]], { silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gTa', [[<cmd> TableAddFormula <CR>]], { silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gTr', [[<cmd> TableAddFormula <CR>]], { silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gTs', [[<cmd> TableSort <CR>]], { silent = true })
			vim.api.nvim_set_keymap('n', '<leader>gTS', [[<cmd> Tableize <CR>]], { silent = true })

			if pcall(require, "which-key") then
				local wk = require("which-key")
				wk.register({ name = "TableMode",
					t = "Toggle Table Mode",
					e = "Eval Formula Line",
					a = "Add Formula",
					r = "Recalculate",
					s = "Sort",
					S = "Tableize",
				}, { mode ='n', prefix = "<leader>gT" })
			end
		end,
	})
end

vim.g.table_mode_disable_mappings = 1
vim.g.table_mode_map_prefix = "<leader>gT"
autocmd_vim_table_mode()
setup_key_vim_table_mode()
setup_key_tabular()
