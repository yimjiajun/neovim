-- NORMAL
-- window
vim.api.nvim_set_keymap('n', '<S-h>', '<C-w>h', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-l>', '<C-w>l', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Enter>', '<cmd> set hlsearch! <CR>', { noremap = true, silent = true})
-- buffer
if vim.g.custom.buffer_display == 1 then
	vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd> BufferLineCyclePrev <CR>', { noremap = true, silent = true})
	vim.api.nvim_set_keymap('n', '<Tab>', '<cmd> BufferLineCycleNext <CR>', { noremap = true, silent = true})
else
	vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd> bp <CR>', { noremap = true, silent = true})
	vim.api.nvim_set_keymap('n', '<Tab>', '<cmd> bn <CR>', { noremap = true, silent = true})
end
vim.api.nvim_set_keymap('n', '<C-c>', '<cmd> bdelete <CR>', { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', 'x', '\"_x', { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', 'X', '\"_X', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<CR>', { noremap = true, silent = true})
-- file
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>w<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-s>', '<cmd>w<CR>', { noremap = true, silent = true})
-- INSERT
-- move
vim.api.nvim_set_keymap('i', '<C-b>', '<Left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<esc>b', '<C-o>b', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-d>', '<del>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-f>', '<Right>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<esc>f', '<C-o>w', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', 'lkj', '<ESC>', { noremap = true, silent = true})
-- TERMINAL
vim.api.nvim_set_keymap('t', 'lkj', '<C-\\><C-n>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '\\][', '<C-c> exit<CR>', { noremap = true, silent = true})
-- COMMAND LINE
vim.api.nvim_set_keymap('c', '<C-l>', '<Right>', { noremap = true, silent = true})
-- VISUAL
-- Don't yank on delete char
vim.api.nvim_set_keymap("v", "x", '\"_x', { noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "X", '\"_X', { noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "p", '\"_dP', { noremap = true, silent = true})

-- Open links under cursor in browser with gx
if vim.fn.has('macunix') == 1 then
	vim.api.nvim_set_keymap("n", "gx", "<cmd> silent execute '!open ' . shellescape('<cWORD>') <CR>", { noremap = true, silent = true})
else
	vim.api.nvim_set_keymap("n", "gx", "<cmd> silent execute '!xdg-open ' . shellescape('<cWORD>') <CR>", { noremap = true, silent = true})
end
