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
	vim.api.nvim_set_keymap('n', "z=", [[<cmd> lua require('telescope.builtin').spell_suggest() <CR>]] , { silent = true, desc = 'Spell Suggest' })
end

setting_key_telescope()
