-- vim.cmd([[colorscheme default]])

vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_set_option('timeoutlen', 500)
vim.api.nvim_set_option('updatetime', 400)
-- view
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_win_set_option(0, 'numberwidth', 4)
vim.api.nvim_win_set_option(0, 'relativenumber', true)
vim.api.nvim_win_set_option(0, 'wrap', true)
vim.api.nvim_win_set_option(0, 'linebreak', true)
vim.api.nvim_set_option('splitbelow', true)
vim.api.nvim_set_option('splitright', true)
vim.api.nvim_set_option('wildmenu', true)
-- editor
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('showmatch', true)
vim.api.nvim_set_option('autoindent', true)
-- vim.api.nvim_set_option('cindent', true)
-- vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_set_option('tabstop', 4)
vim.api.nvim_set_option('shiftwidth', 4)
-- Undo and backup options
vim.api.nvim_set_option('undofile', true)
vim.api.nvim_set_option('backup', false)
vim.api.nvim_set_option('writebackup', false)
vim.api.nvim_set_option('swapfile', false)

vim.api.nvim_set_var('mapleader', ' ')
vim.api.nvim_set_var('maplocalleader', ' ')

