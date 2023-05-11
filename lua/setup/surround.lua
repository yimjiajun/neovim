local function Setting_key_surround()
  function Surround_change_pairs()
    local chg = vim.fn.input('Enter change pair: ')
    local rep = vim.fn.input('Enter replace pair: ')
    vim.cmd('norm cs' .. chg .. rep .. '<CR>')
  end

  function Surround_remove_pairs()
    local rm = vim.fn.input('Enter remove pair: ')
    vim.cmd('norm ds' .. rm .. '<CR>')
  end

  function Surround_full_pairs()
    local pair = vim.fn.input('Enter pair: ')
    vim.cmd('norm cst' .. pair .. '<CR>')
  end

  function Surround_word_pairs()
    local pair = vim.fn.input('Enter pair: ')
    vim.cmd('norm ysiw' .. pair .. '<CR>')
  end

  function Surround_line_pairs()
    local pair = vim.fn.input('Enter pair: ')
    vim.cmd('norm yss' .. pair .. '<CR>')
  end

  vim.api.nvim_set_keymap('n', '<leader>gsp', [[<cmd> lua Surround_change_pairs() <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gsr', [[<cmd> lua Surround_remove_pairs() <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gsf', [[<cmd> lua Surround_full_pairs() <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gsw', [[<cmd> lua Surround_word_pairs() <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gsl', [[<cmd> lua Surround_line_pairs() <CR>]], { silent = true })

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

Setting_key_surround()
