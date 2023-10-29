local function tabular_align()
	local delimiter = vim.fn.input('Enter delimiter: ')

	if delimiter == '' then
		return
	end

	vim.cmd('silent! Tabularize /' .. delimiter)
end

local function setup_key_tabular()
	local function setup_keymap()
		local keymap = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }
		keymap('n', '<Leader>gt', [[<cmd> lua require('plugin.vim-markdown').Align() <CR>]], opts)
		keymap('v', '<Leader>gt', [[<cmd> lua require('plugin.vim-markdown').Align() <CR>]], opts)

		if pcall(require, "which-key") then
			local wk = require("which-key")
			wk.register({ t = "TableMode" }, { mode ='n', prefix = "<leader>g" })
			wk.register({ t = "TableMode" }, { mode ='v', prefix = "<leader>g" })
		end
	end

	return {
		Keymap = setup_keymap
	}
end

local function setup_vim_table_mode()
	local function setup_autocmd()
		vim.api.nvim_exec([[
			augroup vim-markdown-plugin
			autocmd!
			autocmd FileType markdown,org let g:table_mode_corner='|' | execute 'TableModeEnable'
			augroup END
		]], false)
	end

	local function setup_keymap()
		vim.api.nvim_create_augroup( "vim-markdown-plugin", { clear = true })
		vim.api.nvim_create_autocmd( "FileType", {
			desc = "Setup keymapping for markdown table",
			group = "vim-markdown-plugin",
			pattern = "markdown",
			callback = function()
				local keymap = vim.api.nvim_set_keymap
				local opts = { silent = true }
				keymap('n', '<leader>gTt', [[<cmd> TableModeToggle <CR>]], opts)
				keymap('n', '<leader>gTe', [[<cmd> TableEvalFormulaLine <CR>]], opts)
				keymap('n', '<leader>gTa', [[<cmd> TableAddFormula <CR>]], opts)
				keymap('n', '<leader>gTr', [[<cmd> TableAddFormula <CR>]], opts)
				keymap('n', '<leader>gTs', [[<cmd> TableSort <CR>]], opts)
				keymap('n', '<leader>gTS', [[<cmd> Tableize <CR>]], opts)

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

	return {
		Autocmd = setup_autocmd,
		Keymap = setup_keymap
	}
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

local function init()
	if pcall(require, "vim-table-mode") then
		vim.g.table_mode_disable_mappings = 1
		vim.g.table_mode_map_prefix = "<leader>gT"
	end
end

local function setup()
	if pcall(require, "vim-table-mode") then
		setup_vim_table_mode.Autocmd()
		setup_vim_table_mode.Keymap()
	end

	if pcall(require, "tabular") then
		setup_key_tabular().Keymap()
	end

	setup_vim_markdown()
end

return {
	Align = tabular_align,
	Setup = setup,
	Init = init,
}
