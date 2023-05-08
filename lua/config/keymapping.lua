keyfunc = require("config.function")

-- Define which_key_map table
vim.g.which_key_map = {}
vim.g.which_key_map_visual = {}
vim.g.which_key_map.g = { name = '+ Global Plug' }
vim.g.which_key_map.f = { name = '+ Finder' }
vim.g.which_key_map.t = { name = '+ Toggle' }
vim.g.which_key_map.l = { name = '+ Lsp' }

local function setting_key_move()
  vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { silent = true })
  vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { silent = true })
end

local function setting_key_buffer()
  vim.api.nvim_set_keymap('i', '<C-s>', '<C-o>:w<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { silent = true })
  vim.api.nvim_set_keymap('n', '<esc><esc>', ':bd<CR>', { silent = true })

  vim.g.which_key_map.b = 'Buffers'
  vim.api.nvim_set_keymap('n', '<Leader>b', ':call M_buffer("list")<CR>', { silent = true })
  vim.g.which_key_map.m = 'Marks'
  vim.api.nvim_set_keymap('n', '<Leader>m', ':call M_marks("default")<CR>', { silent = true })
end

local function setting_key_view()
  vim.api.nvim_set_keymap('n', '<BS>', ':set hlsearch!<CR>', { silent = true })

  if vim.fn.isdirectory(vim.env.HOME .. '/.vim/plugged/tagbar') then
    vim.g.which_key_map.T = 'Tagbar'
    vim.api.nvim_set_keymap('n', '<Leader>T', ':TagbarToggle<CR>', { silent = true })
  end
end

local function setting_key_edit()
  vim.api.nvim_set_keymap('i', 'lkj', '<ESC>', { noremap = true })
  vim.api.nvim_set_keymap('t', 'lkj', '<ESC>', { noremap = true })
  vim.api.nvim_set_keymap('t', '\\][', '<C-c>exit<CR>', { noremap = true })
  vim.api.nvim_set_keymap('i', '()', '()<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', '{}', '{}<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', '""', '""<ESC>i', { noremap = true })
  vim.api.nvim_set_keymap('i', "''", "''<ESC>i", { noremap = true })
  vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '(<CR>', '(<CR>)<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '[<CR>', '[<CR>]<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', '"<CR>', '"<CR>"<C-o>O', { noremap = true })
  vim.api.nvim_set_keymap('i', "'<CR>", "'<CR>'<C-o>O", { noremap = true })

  if vim.fn.isdirectory(vim.fn.stdpath('data')..'/plugged/vim-easy-align') == 1 then
    vim.g.which_key_map.t.a  = 'Alignment'
    vim.api.nvim_set_keymap('n', '<Leader>ta', '<Plug>(LiveEasyAlign)', { silent = true })
    vim.api.nvim_set_keymap('x', '<Leader>ta', '<Plug>(LiveEasyAlign)', { silent = true })
  end
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
  vim.g.which_key_map.e = 'Explorer'
  vim.api.nvim_set_keymap('n', '<Leader>e', ':Lexplore<CR>', { silent = true })
  vim.g.which_key_map.E = 'Explorer->file'
  vim.api.nvim_set_keymap('n', '<Leader>E', ':Explore<CR>', { silent = true })
end


local function setting_key_search()
    vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd> lua keyfunc.SearchFile() <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fw', [[<cmd> lua keyfunc.SearchWord(" ") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fc', [[<cmd> lua keyfunc.SearchWord("*.c") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fC', [[<cmd> lua keyfunc.SearchWord("*.{c,h,cpp}") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd> lua keyfunc.SearchWord("*.h") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd> lua keyfunc.SearchWord("*.{dts,dtsi}") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fA', [[<cmd> lua keyfunc.FuzzySearch(" ") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fa', [[<cmd> lua keyfunc.FuzzySearch(" ") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fq', [[<cmd> lua keyfunc.FuzzySearch("*." .. vim.fn.input("Enter FileType: ")) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fQ', [[<cmd> lua keyfunc.FuzzySearch(vim.fn.input("Enter FileType: ")) <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fK', [[<cmd> lua keyfunc.SearchWord("Kconfig") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fk', [[<cmd> lua keyfunc.SearchWord("*.conf") <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fm', [[<cmd> lua keyfunc.SearchWord("CMakeLists.txt")  <CR>]], {silent = true})
    vim.api.nvim_set_keymap('n', '<Leader>fv', [[<cmd> lua keyfunc.FuzzySearch(vim.fn.input("Enter FileType: ", "*.")) <CR>]], {silent = true})
end

local function setting_key_git()
  vim.api.nvim_set_keymap('n', '<Leader>ggl', [[<cmd> lua keyfunc.GitLog("graph") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.L = 'log (info..)'
  vim.api.nvim_set_keymap('n', '<Leader>ggL', [[<cmd> lua keyfunc.GitLog("default") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.H = 'log (diff)'
  vim.api.nvim_set_keymap('n', '<Leader>ggH', [[<cmd> lua keyfunc.GitLog("diff") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.C = 'commit count'
  vim.api.nvim_set_keymap('n', '<Leader>ggC', [[<cmd> lua keyfunc.GitLog("commit_count") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.d = 'diff'
  vim.api.nvim_set_keymap('n', '<Leader>ggd', [[<cmd> lua keyfunc.GitDiff("default") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.D = 'diff (prev)'
  vim.api.nvim_set_keymap('n', '<Leader>ggD', [[<cmd> lua keyfunc.GitDiff("previous") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.h = 'diff (staging)'
  vim.api.nvim_set_keymap('n', '<Leader>ggh', [[<cmd> lua keyfunc.GitDiff("staging") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.s = 'status'
  vim.api.nvim_set_keymap('n', '<Leader>ggs', [[<cmd> lua keyfunc.GitStatus("default") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.S = 'status (short)'
  vim.api.nvim_set_keymap('n', '<Leader>ggS', [[<cmd> lua keyfunc.GitStatus("short") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.w = 'whitespace check'
  vim.api.nvim_set_keymap('n', '<Leader>ggw', [[<cmd> lua keyfunc.GitStatus("check_whitespace") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.p = 'add (patch)'
  vim.api.nvim_set_keymap('n', '<Leader>ggp', [[<cmd> lua keyfunc.GitAdd("patch") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.a = 'add'
  vim.api.nvim_set_keymap('n', '<Leader>gga', [[<cmd> lua keyfunc.GitAdd("default") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.A = 'add (all)'
  vim.api.nvim_set_keymap('n', '<Leader>ggA', [[<cmd> lua keyfunc.GitAdd("all") <CR>]], { silent = true })
  -- vim.g.which_key_map.g.g.c = 'commit'
  vim.api.nvim_set_keymap('n', '<Leader>ggc', [[<cmd> lua keyfunc.GitCommit("default") <CR>]], { silent = true })
end

setting_key_move()
setting_key_buffer()
setting_key_view()
setting_key_edit()
setting_key_yank()
setting_key_leader()
setting_key_newtr()
setting_key_search()
setting_key_git()
