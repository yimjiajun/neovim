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

local function setting_key_surround()
	local k = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	k('n', '<leader>gsp', [[<cmd> lua require('setup.surround').change_pairs() <CR>]], opts)
	k('n', '<leader>gsr', [[<cmd> lua require('setup.surround').remove_pairs() <CR>]], opts)
	k('n', '<leader>gsf', [[<cmd> lua require('setup.surround').full_pairs() <CR>]], opts)
	k('n', '<leader>gsw', [[<cmd> lua require('setup.surround').word_pairs() <CR>]], opts)
	k('n', '<leader>gsl', [[<cmd> lua require('setup.surround').line_pairs() <CR>]], opts)

  if pcall(require, "which-key") then
	  local wk = require("which-key")
	  wk.register({
		  s = { name = "Surround",
			  p = 'change pairs',
			  r = 'remove pairs',
			  f = 'full pairs',
			  w = 'word pairs',
			  l = 'line pairs',
		  },
	  }, { prefix = "<leader>g"})
  end
end

setting_key_surround()

return {
	change_pairs = surround_change_pairs,
	remove_pairs = surround_remove_pairs,
	full_pairs = surround_full_pairs,
	word_pairs = surround_word_pairs,
	line_pairs = surround_line_pairs,
}
