KeyFunc = require("config.function")

local function setting_key_move()
  vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { silent = true })
  vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { silent = true })
end

local function setting_key_buffer()
  vim.api.nvim_set_keymap('i', '<C-s>', '<C-o>:w<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<C-c>', ':bd<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<esc><BS>', ':cclose<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>c', ':cclose <CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>C', ':copen <CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>j', ':cn <CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>k', ':cp <CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>w', [[<cmd> lua KeyFunc.GetBuffers("list") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>q', [[<cmd> lua KeyFunc.GetMarks("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd> lua KeyFunc.GetJumplist("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>r', [[<cmd> lua KeyFunc.GetRegisterList("default") <CR>]], { silent = true })
end

local function setting_key_view()
  vim.api.nvim_set_keymap('n', '<BS>', ':set hlsearch!<CR>', { silent = true })
end

local function setting_key_edit()
  vim.api.nvim_set_keymap('i', 'lkj', '<ESC>', { noremap = true })
  vim.api.nvim_set_keymap('t', 'lkj', '<ESC>', { noremap = true })
  vim.api.nvim_set_keymap('t', '\\][', '<C-c> exit <CR>', { noremap = true })
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
    vim.api.nvim_set_keymap('n', '<Leader>fw', [[<cmd> lua KeyFunc.SearchWord("", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd> lua KeyFunc.SearchWord("./**/*.c", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fC', [[<cmd> lua KeyFunc.SearchWord("./**/*.{c,h,cpp}", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd> lua KeyFunc.SearchWord("./**/*.h", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd> lua KeyFunc.SearchWord("./**/*.{dts,dtsi}", "normal") <CR>]], {silent = true})
	vim.api.nvim_set_keymap('n', '<Leader>fA', [[<cmd> lua KeyFunc.SearchWord("./**/*", "normal") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd> lua KeyFunc.SearchWord("./**/*.*", "normal") <CR>]], {silent = true})
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
  vim.api.nvim_set_keymap('n', '<leader>s', [[<cmd> lua KeyFunc.Session("load") <CR>]], {silent = true})
end

local function setting_key_features()
  vim.api.nvim_set_keymap('n', '<leader>tc', [[<cmd> lua KeyFunc.CreateCtags() <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd> lua KeyFunc.Build() <CR>]], {silent = true})
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
