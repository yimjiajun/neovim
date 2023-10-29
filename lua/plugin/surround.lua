local function surround_change_pairs()
	local chg = vim.fn.input('Enter change pair: ')
	local rep = vim.fn.input('Enter replace pair: ')
	vim.cmd('norm cs' .. chg .. rep .. '<CR>')
end

local function surround_remove_pairs()
	local rm = vim.fn.input('Enter remove pair: ')
	vim.cmd('norm ds' .. rm .. '<CR>')
end


local function surround_full_pairs()
	local pair = vim.fn.input('Enter pair: ')
	vim.cmd('norm cst' .. pair .. '<CR>')
end

local function surround_word_pairs()
	local pair = vim.fn.input('Enter pair: ')
	vim.cmd('norm ysiw' .. pair .. '<CR>')
end

local function surround_line_pairs()
	local pair = vim.fn.input('Enter pair: ')
	vim.cmd('norm yss' .. pair .. '<CR>')
end

local function setup_keymap()
	local keymap = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }
	local prefix_key = '<leader>gs'

	keymap('n', prefix_key .. 'p', [[<cmd> lua require('plugin.surround').ChangePairs() <CR>]], opts)
	keymap('n', prefix_key .. 'r', [[<cmd> lua require('plugin.surround').RemovePairs() <CR>]], opts)
	keymap('n', prefix_key .. 'f', [[<cmd> lua require('plugin.surround').FullPairs() <CR>]], opts)
	keymap('n', prefix_key .. 'w', [[<cmd> lua require('plugin.surround').WordPairs() <CR>]], opts)
	keymap('n', prefix_key .. 'l', [[<cmd> lua require('plugin.surround').LinePairs() <CR>]], opts)

  if pcall(require, "which-key") then
	  local wk = require("which-key")

		wk.register({ s = { name = "Surround",
			p = 'change pairs',
			r = 'remove pairs',
			f = 'full pairs',
			w = 'word pairs',
			l = 'line pairs',
		}}, { prefix = "<leader>g"})
  end
end

local function setup()
	setup_keymap()
end

return {
	ChangePairs = surround_change_pairs,
	RemovePairs = surround_remove_pairs,
	FullPairs = surround_full_pairs,
	WordPairs = surround_word_pairs,
	LinePairs = surround_line_pairs,
	Setup = setup,
}
