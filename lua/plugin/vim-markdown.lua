local function init()
	vim.g.table_mode_disable_mappings = 1
	vim.g.table_mode_map_prefix = "<leader>gT"
end

local function tabular_align()
	local delimiter = vim.fn.input('Enter delimiter: ')
	vim.cmd('Tabularize /' .. delimiter)
end

local function setup_key_tabular()
	if pcall(require, "tabular") == 0 then
		return
	end

	vim.api.nvim_set_keymap('n', '<Leader>gt', [[<cmd> lua require('plugin.vim-markdown').Align() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('v', '<Leader>gt', [[<cmd> lua require('plugin.vim-markdown').Align() <CR>]], { silent = true })

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

local function setup_vim_markdown()
	vim.opt.conceallevel = 2
	vim.g.vim_markdown_new_list_item_indent = 2
	vim.g.vim_markdown_strikethrough = 1
	vim.g.vim_markdown_folding_level = 1
	vim.g.vim_markdown_folding_style_pythonic = 1
	vim.g.vim_markdown_override_foldtext = 1
	vim.g.vim_markdown_follow_anchor = 1
	vim.g.vim_markdown_toc_autofit = 1
	vim.g.vim_markdown_fenced_languages = {
		"bash=sh",
		"c",
		"cpp",
		"css",
		"dockerfile",
		"html",
		"java",
		"javascript",
		"js=javascript",
		"json",
		"lua",
		"python",
		"sh",
		"vim",
		"yaml",
	}
end

autocmd_vim_table_mode()
setup_key_vim_table_mode()
setup_key_tabular()
setup_vim_markdown()

local ret = {
	init = init,
	Align = tabular_align,
}

return ret
