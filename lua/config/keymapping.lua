keyfunc = require("config.function")

local function setting_key_move()
  vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { silent = true })
  vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { silent = true })
end

local function setting_key_buffer()
  vim.api.nvim_set_keymap('i', '<C-s>', '<C-o>:w<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<esc><esc>', ':bd<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd> lua keyfunc.GetBuffers("list") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>m', [[<cmd> lua keyfunc.GetMarks("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd> lua keyfunc.GetJumplist("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<leader>r', [[<cmd> lua keyfunc.GetRegisterList("default") <CR>]], { silent = true })
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
    vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd> lua keyfunc.SearchFile() <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fw', [[<cmd> lua keyfunc.SearchWord(" ") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd> lua keyfunc.SearchWord("*.c") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fC', [[<cmd> lua keyfunc.SearchWord("*.{c,h,cpp}") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd> lua keyfunc.SearchWord("*.h") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd> lua keyfunc.SearchWord("*.{dts,dtsi}") <CR>]], {silent = true})
	vim.api.nvim_set_keymap('n', '<Leader>fA', [[<cmd> lua keyfunc.FuzzySearch(" ", 0) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd> lua keyfunc.FuzzySearch(" ", 0) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fq', [[<cmd> lua keyfunc.FuzzySearch("*." .. vim.fn.input("Enter FileType: "), 0) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fQ', [[<cmd> lua keyfunc.FuzzySearch(vim.fn.input("Enter FileType: "), 0) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fK', [[<cmd> lua keyfunc.SearchWord("Kconfig") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fk', [[<cmd> lua keyfunc.SearchWord("*.conf") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fm', [[<cmd> lua keyfunc.SearchWord("CMakeLists.txt")  <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fv', [[<cmd> lua keyfunc.FuzzySearch(vim.fn.input("Enter FileType: ", "*."), 1) <CR>]], {silent = true})
end

local function setting_key_git()
  vim.api.nvim_set_keymap('n', '<Leader>ggl', [[<cmd> lua keyfunc.GitLog("graph") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggL', [[<cmd> lua keyfunc.GitLog("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggH', [[<cmd> lua keyfunc.GitLog("diff") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggC', [[<cmd> lua keyfunc.GitLog("commit_count") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggd', [[<cmd> lua keyfunc.GitDiff("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggD', [[<cmd> lua keyfunc.GitDiff("previous") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggh', [[<cmd> lua keyfunc.GitDiff("staging") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggs', [[<cmd> lua keyfunc.GitStatus("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggS', [[<cmd> lua keyfunc.GitStatus("short") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggw', [[<cmd> lua keyfunc.GitStatus("check_whitespace") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggp', [[<cmd> lua keyfunc.GitAdd("patch") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>gga', [[<cmd> lua keyfunc.GitAdd("default") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggA', [[<cmd> lua keyfunc.GitAdd("all") <CR>]], { silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>ggc', [[<cmd> lua keyfunc.GitCommit("default") <CR>]], { silent = true })
end

local function setting_key_terminal()
  vim.api.nvim_set_keymap('n', '<leader>ts', [[<cmd> lua keyfunc.Terminal("split") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tv', [[<cmd> lua keyfunc.Terminal("vertical") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd> lua keyfunc.Terminal("default") <CR>]], {silent = true})
  vim.api.nvim_set_keymap('n', '<leader>tF', [[<cmd> lua keyfunc.Terminal("selection") <CR>]], {silent = true})
end

local function setting_key_session()
  vim.api.nvim_set_keymap('n', '<leader>s', [[<cmd> lua keyfunc.Session("load") <CR>]], {silent = true})
end

local function setting_key_features()
  vim.api.nvim_set_keymap('n', '<leader>tc', [[<cmd> lua keyfunc.CreateCtags() <CR>]], {silent = true})
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
