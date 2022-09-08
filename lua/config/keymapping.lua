-- NORMAL
-- window
vim.api.nvim_set_keymap('n', '<S-h>', '<C-w>h', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-l>', '<C-w>l', { noremap = true, silent = true})
-- buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-c>', '<cmd>bdelete<CR>', { noremap = true, silent = true})
-- file
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>w<CR>', { noremap = true, silent = true})
-- INSERT
-- move
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'lkj', '<ESC>', { noremap = true, silent = true})
-- TERMINAL
vim.api.nvim_set_keymap('t', 'lkj', '<C-\\><C-n>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '\\][', '<C-c> exit<CR>', { noremap = true, silent = true})
