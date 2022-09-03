local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

local Terminal  = require('toggleterm.terminal').Terminal
	local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
		function _lazygit_toggle()
		  lazygit:toggle()
		end
	local htop = Terminal:new({ cmd = "htop", direction = "float", hidden = true })
		function _htop_toggle()
		  htop:toggle()
		end
	local ncdu = Terminal:new({ cmd = "ncdu", direction = "float", hidden = true })
		function _ncdu_toggle()
		  ncdu:toggle()
		end
wk.register({
	f = {
		name = "Find", -- optional group name
		a = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.*'})<CR>", "live grep"},
		s = { "<cmd> lua require('telescope.builtin').grep_string()<CR>", "string"},
		F = { "<cmd> lua require('telescope.builtin').find_files({hiddne=true}, {no_ignore=true})<CR>", "FILES"},
		f = { "<cmd> lua require('telescope.builtin').find_files()<CR>", "files"},
		S = {
			name = "Specific",
			c = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.c'})<CR>", "c"},
			h = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.h'})<CR>", "header"},
			d = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.dts'})<CR>", "dts"},
			D = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.dtsi'})<CR>", "dtsi"},
		},
	},
	e = { "<cmd> NvimTreeToggle <CR>", "file bar" },
	E = { "<cmd> NvimTreeFindFile <CR>", "file location" },
	g = {
		name = "git",
		t = { "<cmd>lua _lazygit_toggle()<CR>", "lazygit" },
	},
	T = { "<cmd>TagbarToggle<CR>", "tag bar" },
	t = {
		name = "Toggle",
		f = { "<cmd> ToggleTerm direction=float <CR>", "terminal" },
		v = { "<cmd> ToggleTerm direction=vertical size=50<CR>", "terminal(v)" },
		t = { "<cmd> ToggleTerm direction=tab <CR>", "terminal(t)" },
		h = { "<cmd> ToggleTerm direction=horizontal <CR>", "terminal(h)" },
		s = { "<cmd>lua _htop_toggle()<CR>", "system view" },
		d = { "<cmd>lua _ncdu_toggle()<CR>", "disk view" },
	},
	s = {
		name = "Session",
		l = { "<cmd>SessionManager load_last_session<CR>", "load last session" },
		d = { "<cmd> SessionManager load_current_dir_session<CR>", "load current dir session" },
		L = { "<cmd> SessionManager load_session<CR>", "load session" },
		D = { "<cmd> SessionManager delete_session<CR>", "delete session" },
		s = { "<cmd> SessionManager save_current_session<CR>", "save session" },
	},
}, { prefix = "<leader>" })

vim.api.nvim_set_keymap('n', '<S-h>', '<cmd>bprevious<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-l>', '<cmd>bNext<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-c>', '<cmd>bdelete<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-Space>', '<ESC>', { noremap = true, silent = true})
