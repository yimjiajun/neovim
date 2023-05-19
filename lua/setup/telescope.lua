require('telescope').setup{
	defaults = {
		layout_strategy = 'horizontal',
			layout_config = {
			height = 0.80,
			width = 0.95,
			prompt_position = 'bottom',
			-- mirror = true,
		},
	prompt_prefix='  ',
	},
}

local function setting_key_telescope()
	vim.api.nvim_set_keymap('n', "z=",
		[[<cmd> lua require('telescope.builtin').spell_suggest() <CR>]],
		{ silent = true, desc = 'Spell Suggest' })

	if vim.fn.filereadable("tags") == 1 then
		vim.api.nvim_set_keymap('n', "<leader>tt",
			[[<cmd> lua require('telescope.builtin').current_buffer_tags() <CR>]],
			{ silent = true, desc = 'buffer tags list' })
	end

	vim.api.nvim_set_keymap('n', "<leader>ts",
		[[<cmd> lua require('telescope.builtin').tagstack() <CR>]],
		{ silent = true, desc = 'tag stack selection' })

	vim.api.nvim_set_keymap('n', "<leader>fb",
		[[<cmd> lua require('telescope.builtin').current_buffer_fuzzy_find() <CR>]],
		{ silent = true, desc = 'search current buffer' })

	vim.api.nvim_set_keymap('n', "<leader>ft",
		[[<cmd> lua require('telescope.builtin').tags() <CR>]],
		{ silent = true, desc = 'search from tags' })

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({
			t = { t = "tags list",
				s = "tags stack" },
			f = {
				b = "buffer search",
				t = "tags", },
		}, { prefix = "<leader>" })
	end
end

setting_key_telescope()
