KeyFunc = require("config.function")

local function setting_key_move()
  vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { silent = true })
  vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { silent = true })
  vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { silent = true })
  vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { silent = true })
end

local function setting_key_buffer()
  vim.api.nvim_set_keymap('i', '<C-s>', '<C-o>:w<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader><BS>', [[<cmd>%bd|e#|bd#|'<CR>|<CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<C-c>', ':bd<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<esc><BS>', ':cclose<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', 'lkj', '<cmd>bp<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', 'jkl', '<cmd>bn<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>c', ':lua KeyFunc.ToggleQuickFix() <CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<M-j>', '<cmd> cn <CR>z.', { silent = true })
  vim.api.nvim_set_keymap('n', '<M-k>', '<cmd> cp <CR>z.', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>w', [[<cmd> lua KeyFunc.GetBuffers("list") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>q', [[<cmd> lua KeyFunc.GetMarks("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd> lua KeyFunc.GetJumplist("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>r', [[<cmd> lua KeyFunc.GetRegisterList("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>te', [[<cmd> lua KeyFunc.SetFileFormat() <CR>]], { silent = true })
end

local function setting_key_view()
  vim.api.nvim_set_keymap('n', '<BS>', ':set hlsearch!<CR>', { silent = true })
end

local function setting_key_edit()
  vim.api.nvim_set_keymap('i', 'jkl', '<ESC>', { noremap = true })
  vim.api.nvim_set_keymap('i', 'lkj', '<ESC><cmd>bp<CR>', { noremap = true })
  vim.api.nvim_set_keymap('t', 'jkl', '<C-\\><C-n>', { noremap = true })
  vim.api.nvim_set_keymap('t', 'lkj', '<C-\\><C-n><cmd>bp<CR><cmd>only<CR>', { noremap = true })
  vim.api.nvim_set_keymap('i', '()', '()<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', '{}', '{}<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', '""', '""<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', "''", "''<ESC>i", { noremap = true })
  vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '(<CR>', '(<CR>)<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '[<CR>', '[<CR>]<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '"<CR>', '"<CR>"<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', "'<CR>", "'<CR>'<C-o>O", { noremap = true })
end

local function setting_key_yank()
  vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
  vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true })
  vim.api.nvim_set_keymap('v', 'x', '"_x', { noremap = true })
  vim.api.nvim_set_keymap('v', 'X', '"_X', { noremap = true })
  vim.api.nvim_set_keymap('v', 'p', '"_dp', { noremap = true })
end

local function setting_key_leader()
  if vim.fn.has('nvim-0.5') == 1 then
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
  else
    vim.api.nvim_set_var('mapleader', ' ')
    vim.api.nvim_set_var('maplocalleader', ' ')
  end
end

local function setting_key_newtr()
  vim.api.nvim_set_keymap('n', '<Leader>e', ':Lexplore<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>E', ':Explore<CR>', { silent = true })
end

local function setting_key_search()
    vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd> lua KeyFunc.SearchFile() <CR>]], {silent = true})
	vim.api.nvim_set_keymap('n', '<Leader>fA', [[<cmd> lua KeyFunc.SearchWord(nil, "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd> lua KeyFunc.SearchWord("./**/*", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fw', [[<cmd> lua KeyFunc.SearchWord(nil, "cursor") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fW', [[<cmd> lua KeyFunc.SearchWord("", "cursor") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd> lua KeyFunc.SearchWord("./**/*.c", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fC', [[<cmd> lua KeyFunc.SearchWord("./**/*.{c,h,cpp}", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd> lua KeyFunc.SearchWord("./**/*.h", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd> lua KeyFunc.SearchWord("./**/*.{dts,dtsi}", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fK', [[<cmd> lua KeyFunc.SearchWord("./**/Kconfig", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fk', [[<cmd> lua KeyFunc.SearchWord("./**/*.conf", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fm', [[<cmd> lua KeyFunc.SearchWord("./**/CMakeLists.txt", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fM', [[<cmd> lua KeyFunc.SearchWord("./**/*.{md,rst,txt}", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fv', [[<cmd> lua KeyFunc.SearchWord("", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fV', [[<cmd> lua KeyFunc.SearchWord("", "complete") <CR>]], {silent = true})
end

local function setting_key_git()
  vim.api.nvim_set_keymap('n', '<Leader>ggl', [[<cmd> lua KeyFunc.GitLog("graph") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggL', [[<cmd> lua KeyFunc.GitLog("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggH', [[<cmd> lua KeyFunc.GitLog("diff") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggC', [[<cmd> lua KeyFunc.GitLog("commit_count") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggd', [[<cmd> lua KeyFunc.GitDiff("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggD', [[<cmd> lua KeyFunc.GitDiff("previous") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggh', [[<cmd> lua KeyFunc.GitDiff("staging") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggs', [[<cmd> lua KeyFunc.GitStatus("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggS', [[<cmd> lua KeyFunc.GitStatus("short") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggw', [[<cmd> lua KeyFunc.GitStatus("check_whitespace") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggp', [[<cmd> lua KeyFunc.GitAdd("patch") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>gga', [[<cmd> lua KeyFunc.GitAdd("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggA', [[<cmd> lua KeyFunc.GitAdd("all") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggc', [[<cmd> lua KeyFunc.GitCommit("default") <CR>]], { silent = true })
end

local function setting_key_terminal()
  vim.api.nvim_set_keymap('n', '<leader>ts', [[<cmd> lua KeyFunc.Terminal("split") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tv', [[<cmd> lua KeyFunc.Terminal("vertical") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd> lua KeyFunc.Terminal("default") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tF', [[<cmd> lua KeyFunc.Terminal("selection") <CR>]], {silent = true})
end

local function setting_key_session()
  vim.api.nvim_set_keymap('n', '<leader>os', [[<cmd> lua KeyFunc.GetSession() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>oS', [[<cmd> lua KeyFunc.SelSession() <CR>]], {silent = true})
end

local function setting_key_features()
  vim.api.nvim_set_keymap('n', '<leader>tc', [[<cmd> lua KeyFunc.CreateCtags() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd> lua KeyFunc.Build() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>B', [[<cmd> lua KeyFunc.Build("latest") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>vb',

		[[<cmd> lua require("features.bookmarks").Review() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>sb',
		[[<cmd> lua require("features.bookmarks").Save() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>sB',
		[[<cmd> lua require("features.bookmarks").Rename() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Sb',
		[[<cmd> lua require("features.bookmarks").Remove() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>SB',
		[[<cmd> lua require("features.bookmarks").Clear() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>ob',
		[[<cmd> lua require("features.bookmarks").Get() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>oB',
		[[<cmd> lua require("features.bookmarks").GetAll() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<M-n>',
		[[<cmd> lua require("features.bookmarks").Next() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<M-p>',
		[[<cmd> lua require("features.bookmarks").Prev() <CR>]],{silent = true})

  vim.api.nvim_set_keymap('n', '<leader>ot',
		[[<cmd> lua require("features.todo").Get() <CR>]],{silent = true})
  vim.api.nvim_set_keymap('n', '<leader>st',
		[[<cmd> lua require("features.todo").Add() <CR>]],{silent = true})

  vim.api.nvim_set_keymap('n', '<leader>sm',
		[[<cmd> lua require('features.marks').Buffer('save') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Sm',
		[[<cmd> lua require('features.marks').Buffer('remove') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>Su',
		[[<cmd> lua require('features.marks').Buffer('clear') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>om',
		[[<cmd> lua require('features.marks').Buffer() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>ou',
		[[<cmd> lua require('features.marks').Buffer('sort') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>sM',
		[[<cmd> lua require('features.marks').All('save') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>SM',
		[[<cmd> lua require('features.marks').All('remove') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>SU',
		[[<cmd> lua require('features.marks').All('clear') <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>oM',
		[[<cmd> lua require('features.marks').All() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>oU',
		[[<cmd> lua require('features.marks').All('universal') <CR>]], {silent = true})
end

setting_key_leader()
setting_key_move()
setting_key_buffer()
setting_key_view()
setting_key_edit()
setting_key_yank()
setting_key_newtr()
setting_key_search()
setting_key_git()
setting_key_terminal()
setting_key_session()
setting_key_features()
