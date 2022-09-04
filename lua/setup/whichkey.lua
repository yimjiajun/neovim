 require("which-key").setup {
	{
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			spelling = {
				enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
				suggestions = 20, -- how many suggestions should be shown in the list?
			},
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},
		-- add operators that will trigger motion and text object completion
		-- to enable all native operators, set the preset / operators plugin above
		operators = { gc = "Comments" },
		key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		popup_mappings = {
			scroll_down = '<c-d>', -- binding to scroll down inside the popup
			scroll_up = '<c-u>', -- binding to scroll up inside the popup
		},
		window = {
			border = "none", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
			winblend = 0
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "left", -- align columns left, center or right
		},
		ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
		triggers = "auto", -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specify a list manually
		triggers_blacklist = {
			-- list of mode / prefixes that should never be hooked by WhichKey
			-- this is mostly relevant for key maps that start with a native binding
			-- most people should not need to change this
			i = { "j", "k" },
			v = { "j", "k" },
		},
	}
}

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
