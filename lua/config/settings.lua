if vim.g.custom.theme ~= "gruvbox" then
	if vim.g.custom.theme ~= "tundra" then
		vim.g.custom.theme = 'zellner'
		vim.g.custom.background = 'light'
		vim.cmd([[colorscheme zellner]])
	end
end

if vim.g.custom.background == 'light' then
	vim.api.nvim_set_option('background', 'light')
else
	vim.api.nvim_set_option('background', 'dark')
end

vim.api.nvim_set_option('hidden', true)
vim.api.nvim_set_option('clipboard', 'unnamedplus')
vim.api.nvim_set_option('lazyredraw', true)
vim.api.nvim_set_option('timeoutlen', 200)
vim.api.nvim_set_option('updatetime', 400)
-- view
vim.api.nvim_set_option('termguicolors', true)
vim.api.nvim_set_option('showmode', true)
vim.api.nvim_set_option('laststatus', 2)
if vim.fn.has('nvim-0.8') == 1 then
	vim.api.nvim_set_option('cmdheight', 1)
end
vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_win_set_option(0, 'numberwidth', 4)
vim.api.nvim_win_set_option(0, 'relativenumber', true)
vim.api.nvim_win_set_option(0, 'wrap', true)
vim.api.nvim_win_set_option(0, 'linebreak', true)
vim.api.nvim_set_option('splitbelow', true)
vim.api.nvim_set_option('splitright', true)
vim.api.nvim_set_option('wildmenu', true)
vim.api.nvim_set_option('cursorline', true)
vim.api.nvim_set_option('cursorcolumn', false)
-- editor
vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)
vim.api.nvim_set_option('showmatch', true)
vim.api.nvim_set_option('autoindent', true)
vim.api.nvim_set_option('smartindent', true)
vim.api.nvim_set_option('list', false)
-- vim.api.nvim_set_option('cindent', true)
-- vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_set_option('tabstop', 2)
vim.api.nvim_set_option('shiftwidth', 2)
-- Undo and backup options
vim.api.nvim_set_option('undofile', true)
vim.api.nvim_set_option('backup', false)
vim.api.nvim_set_option('writebackup', false)
vim.api.nvim_set_option('swapfile', false)

vim.api.nvim_set_var('mapleader', ' ')
vim.api.nvim_set_var('maplocalleader', ' ')
