local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local function setting_key_move()
	keymap('i', '<C-b>', '<Left>', opts)
	keymap('i', '<C-f>', '<Right>', opts)
	keymap('n', '<C-u>', '<C-u>zz', opts)
	keymap('n', '<C-d>', '<C-d>zz', opts)
	keymap('n', 'j', 'jzz', opts)
	keymap('n', 'k', 'kzz', opts)
	keymap('n', 'n', 'nzz', opts)
	keymap('n', 'N', 'Nzz', opts)
	keymap('n', '<C-]>', '<C-]>zz', opts)
	keymap('n', 'gd', 'gdzz', opts)
end

local function setting_key_buffer()
	keymap('i', '<C-s>', '<C-o>:w<CR>', opts)
	keymap('n', '<S-Tab>', ':bp<CR>', opts)
	keymap('n', '<leader><BS>', [[<cmd>%bd|e#|bd#|'<CR>|<CR>]], opts)
	keymap('n', '<Tab>', ':bn<CR>', opts)
	keymap('n', '<C-c>', ':bd<CR>', opts)
	keymap('n', '<esc><BS>', ':cclose<CR>', opts)
	keymap('n', 'lkj', '<cmd>bp<CR>', { noremap = true })
	keymap('n', 'jkl', '<cmd>bn<CR>', { noremap = true })
	keymap('n', '<leader>c', ':lua require("config.function").ToggleQuickFix() <CR>', opts)
	keymap('n', '<M-j>', '<cmd> cn <CR>z.', opts)
	keymap('n', '<M-k>', '<cmd> cp <CR>z.', opts)
	keymap('n', '<leader>w', [[<cmd> lua require("config.function").GetBuffers("list") <CR>]], opts)
	keymap('n', '<leader>q', [[<cmd> lua require("config.function").GetMarks("default") <CR>]], opts)
	keymap('n', '<leader>h', [[<cmd> lua require("config.function").GetJumplist("default") <CR>]], opts)
	keymap('n', '<leader>r', [[<cmd> lua require("config.function").GetRegisterList("default") <CR>]], opts)
	keymap('n', '<leader>te', [[<cmd> lua require("config.function").SetFileFormat() <CR>]], opts)
end

local function setting_key_view()
	keymap('n', '<BS>', ':set hlsearch!<CR>', opts)
end

local function setting_key_edit()
	keymap('i', 'jkl', '<ESC>', opts)
	keymap('i', 'lkj', '<ESC><cmd>bp<CR>', opts)
	keymap('t', 'jkl', '<C-\\><C-n>', opts)
	keymap('t', 'lkj', '<C-\\><C-n><cmd>bp<CR><cmd>only<CR>', opts)
	keymap('i', '()', '()<ESC>i', opts)
	keymap('i', '{}', '{}<ESC>i', opts)
	keymap('i', '""', '""<ESC>i', opts)
	keymap('i', "''", "''<ESC>i", opts)
	keymap('i', '{<CR>', '{<CR>}<C-o>O', opts)
	keymap('i', '(<CR>', '(<CR>)<C-o>O', opts)
	keymap('i', '[<CR>', '[<CR>]<C-o>O', opts)
	keymap('i', '"<CR>', '"<CR>"<C-o>O', opts)
	keymap('i', "'<CR>", "'<CR>'<C-o>O", opts)
end

local function setting_key_yank()
	keymap('n', 'x', '"_x', opts)
	keymap('n', 'X', '"_X', opts)
	keymap('v', 'x', '"_x', opts)
	keymap('v', 'X', '"_X', opts)
	keymap('v', 'p', '"_dp', opts)
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
	keymap('n', '<Leader>e', ':Lexplore<CR>', opts)
	keymap('n', '<Leader>E', ':Explore<CR>', opts)
end

local function setting_key_search()
	keymap('n', '<Leader>ff', [[<cmd> lua require("config.function").SearchFile() <CR>]], opts)
	keymap('n', '<Leader>fA', [[<cmd> lua require("config.function").SearchWord(nil, "normal") <CR>]], opts)
	keymap('n', '<Leader>fa', [[<cmd> lua require("config.function").SearchWord("./**/*", "normal") <CR>]], opts)
	keymap('n', '<Leader>fw', [[<cmd> lua require("config.function").SearchWord(nil, "cursor") <CR>]], opts)
	keymap('n', '<Leader>fW', [[<cmd> lua require("config.function").SearchWord("", "cursor") <CR>]], opts)
	keymap('n', '<Leader>fc', [[<cmd> lua require("config.function").SearchWord("./**/*.c", "normal") <CR>]], opts)
	keymap('n', '<Leader>fC', [[<cmd> lua require("config.function").SearchWord("./**/*.{c,h,cpp}", "normal") <CR>]], opts)
	keymap('n', '<Leader>fh', [[<cmd> lua require("config.function").SearchWord("./**/*.h", "normal") <CR>]], opts)
	keymap('n', '<Leader>fd',
		[[<cmd> lua require("config.function").SearchWord("./**/*.{dts,dtsi}", "normal") <CR>]], opts)
	keymap('n', '<Leader>fK', [[<cmd> lua require("config.function").SearchWord("./**/Kconfig", "normal") <CR>]], opts)
	keymap('n', '<Leader>fk', [[<cmd> lua require("config.function").SearchWord("./**/*.conf", "normal") <CR>]], opts)
	keymap('n', '<Leader>fm',
		[[<cmd> lua require("config.function").SearchWord("./**/CMakeLists.txt", "normal") <CR>]], opts)
	keymap('n', '<Leader>fM',
		[[<cmd> lua require("config.function").SearchWord("./**/*.{md,rst,txt}", "normal") <CR>]], opts)
	keymap('n', '<Leader>fv', [[<cmd> lua require("config.function").SearchWord("", "normal") <CR>]], opts)
	keymap('n', '<Leader>fV', [[<cmd> lua require("config.function").SearchWord("", "complete") <CR>]], opts)
end

local function setting_key_git()
	keymap('n', '<Leader>ggl', [[<cmd> lua require("config.function").GitLog("graph") <CR>]], opts)
	keymap('n', '<Leader>ggL', [[<cmd> lua require("config.function").GitLog("default") <CR>]], opts)
	keymap('n', '<Leader>ggH', [[<cmd> lua require("config.function").GitLog("diff") <CR>]], opts)
	keymap('n', '<Leader>ggC', [[<cmd> lua require("config.function").GitLog("commit_count") <CR>]], opts)
	keymap('n', '<Leader>ggd', [[<cmd> lua require("config.function").GitDiff("default") <CR>]], opts)
	keymap('n', '<Leader>ggD', [[<cmd> lua require("config.function").GitDiff("previous") <CR>]], opts)
	keymap('n', '<Leader>ggh', [[<cmd> lua require("config.function").GitDiff("staging") <CR>]], opts)
	keymap('n', '<Leader>ggs', [[<cmd> lua require("config.function").GitStatus("default") <CR>]], opts)
	keymap('n', '<Leader>ggS', [[<cmd> lua require("config.function").GitStatus("short") <CR>]], opts)
	keymap('n', '<Leader>ggw', [[<cmd> lua require("config.function").GitStatus("check_whitespace") <CR>]], opts)
	keymap('n', '<Leader>ggp', [[<cmd> lua require("config.function").GitAdd("patch") <CR>]], opts)
	keymap('n', '<Leader>gga', [[<cmd> lua require("config.function").GitAdd("default") <CR>]], opts)
	keymap('n', '<Leader>ggA', [[<cmd> lua require("config.function").GitAdd("all") <CR>]], opts)
	keymap('n', '<Leader>ggc', [[<cmd> lua require("config.function").GitCommit("default") <CR>]], opts)
end

local function setting_key_terminal()
	keymap('n', '<leader>ts', [[<cmd> lua require("config.function").Terminal("split") <CR>]], opts)
	keymap('n', '<leader>tv', [[<cmd> lua require("config.function").Terminal("vertical") <CR>]], opts)
	keymap('n', '<leader>tf', [[<cmd> lua require("config.function").Terminal("default") <CR>]], opts)
	keymap('n', '<leader>tF', [[<cmd> lua require("config.function").Terminal("selection") <CR>]], opts)
end

local function setting_key_session()
	keymap('n', '<leader>os', [[<cmd> lua require("config.function").GetSession() <CR>]], opts)
	keymap('n', '<leader>oS', [[<cmd> lua require("config.function").SelSession() <CR>]], opts)
end

local function setting_key_features()
	keymap('n', '<leader>tc', [[<cmd> lua require("config.function").CreateCtags() <CR>]], opts)
	keymap('n', '<leader>b', [[<cmd> lua require("config.function").Build() <CR>]], opts)
	keymap('n', '<leader>B', [[<cmd> lua require("config.function").Build("latest") <CR>]], opts)
	keymap('n', '<leader>vb', [[<cmd> lua require("features.bookmarks").Review() <CR>]], opts)
	keymap('n', '<leader>sb', [[<cmd> lua require("features.bookmarks").Save() <CR>]], opts)
	keymap('n', '<leader>sB', [[<cmd> lua require("features.bookmarks").Rename() <CR>]], opts)
	keymap('n', '<leader>Sb', [[<cmd> lua require("features.bookmarks").Remove() <CR>]], opts)
	keymap('n', '<leader>SB', [[<cmd> lua require("features.bookmarks").Clear() <CR>]], opts)
	keymap('n', '<leader>ob', [[<cmd> lua require("features.bookmarks").Get() <CR>]], opts)
	keymap('n', '<leader>oB', [[<cmd> lua require("features.bookmarks").GetAll() <CR>]], opts)
	keymap('n', '<M-n>', [[<cmd> lua require("features.bookmarks").Next() <CR>zz]], opts)
	keymap('n', '<M-p>', [[<cmd> lua require("features.bookmarks").Prev() <CR>zz]], opts)

	keymap('n', '<leader>ot', [[<cmd> lua require("features.todo").Get() <CR>]], opts)
	keymap('n', '<leader>st', [[<cmd> lua require("features.todo").Add() <CR>]], opts)

	keymap('n', '<leader>sm', [[<cmd> lua require('features.marks').Buffer('save') <CR>]], opts)
	keymap('n', '<leader>Sm', [[<cmd> lua require('features.marks').Buffer('remove') <CR>]], opts)
	keymap('n', '<leader>Su', [[<cmd> lua require('features.marks').Buffer('clear') <CR>]], opts)
	keymap('n', '<leader>om', [[<cmd> lua require('features.marks').Buffer() <CR>]], opts)
	keymap('n', '<leader>ou', [[<cmd> lua require('features.marks').Buffer('sort') <CR>]], opts)
	keymap('n', '<leader>sM', [[<cmd> lua require('features.marks').All('save') <CR>]], opts)
	keymap('n', '<leader>SM', [[<cmd> lua require('features.marks').All('remove') <CR>]], opts)
	keymap('n', '<leader>SU', [[<cmd> lua require('features.marks').All('clear') <CR>]], opts)
	keymap('n', '<leader>oM', [[<cmd> lua require('features.marks').All() <CR>]], opts)
	keymap('n', '<leader>oU', [[<cmd> lua require('features.marks').All('universal') <CR>]], opts)
end

local function setup()
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
end

return {
	Setup = setup,
}
