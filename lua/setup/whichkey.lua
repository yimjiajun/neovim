local function _get_event_name(evt)
	local notify_title = ''
	if (evt == 'ranger') then
		notify_title = 'ranger - visual file manager'
	elseif (evt == 'lazygit') then
		notify_title = 'lazygit'
	elseif (evt == 'htop') then
		notify_title = 'htop - interactive process viewer'
	elseif (evt == 'ncdu') then
		notify_title = 'ncdu - NCurese disk usage'
	else
		notify_title = 'UNKNOW'
	end

	return notify_title
end

local function _get_log_lvl_name(lvl)
	local lvl_name
	if (lvl == 'ERROR') then
		lvl_name = vim.log.levels.ERROR
	elseif (lvl == 'WARN') then
		lvl_name = vim.log.levels.WARN
	elseif (lvl == 'INFO') then
		lvl_name = vim.log.levels.INFO
	elseif (lvl == 'TRACE') then
		lvl_name = vim.log.levels.TRACE
	else
		lvl_name = vim.log.levels.DEBUG
	end

	return lvl_name
end

local function _notify_wk(lvl, evt)
	 require('notify')(
	 	"\tNot available.\n\tOnly supported in UNIX",
		_get_log_lvl_name(lvl),
		{ title = _get_event_name(evt)}
	)
end

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local htop = Terminal:new({ cmd = "htop", direction = "float", hidden = true })
local ncdu = Terminal:new({ cmd = "ncdu", direction = "float", hidden = true })
local ranger = Terminal:new({ cmd = "ranger", direction = "float", hidden = true })

function _LAZYGIT_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		lazygit:toggle()
	else
		_notify_wk('ERROR', 'lazygit')
	end
end

function _HTOP_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		htop:toggle()
	else
		_notify_wk('ERROR', 'htop')
	end
end

function _NCDU_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		ncdu:toggle()
	else
		_notify_wk('ERROR', 'ncdu')
	end
end

function _RANGER_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		ranger:toggle()
	else
		_notify_wk('ERROR', 'ranger')
	end
end

local wk = require("which-key")

wk.register({
	f = {
		name = "Find", -- optional group name
		g = { "<cmd> lua require('telescope.builtin').live_grep({glob_pattern='*.*'})<CR>", "live grep"},
		s = { "<cmd> lua require('telescope.builtin').grep_string()<CR>", "string"},
		F = { "<cmd> lua require('telescope.builtin').find_files({hiddne=true}, {no_ignore=true})<CR>", "FILES"},
		f = { "<cmd> lua require('telescope.builtin').find_files()<CR>", "files"},
		h = { "<cmd> lua require('telescope.builtin').oldfiles()<CR>", "recently opened"},
		H = { "<cmd> lua require('telescope.builtin').search_history()<CR>", "search histroy"},
		m = { "<cmd> lua require('telescope.builtin').marks()<CR>", "marks"},
		r = { "<cmd> lua require('telescope.builtin').registers()<CR>", "registers"},
		j = { "<cmd> lua require('telescope.builtin').jumplist()<CR>", "jumplist"},
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
		t = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "lazygit" },
		s = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "status" },
		l = {
			name = "Log",
			l = { "<cmd>lua require('telescope.builtin').git_commits()<CR>", "messages" },
		},
		g = {
			name = "GitSigns",
			s = "stage hunk",
			r = "reset hunk",
			S = "stage buffer",
			u = "undo stage hunk",
			R = "reset buffer",
			p = "preview hunk",
			b = "blame line",
			t = {
				name = "Toggle",
				b = "current blame line",
				d = "delete",
			},
			d = "diff this",
			D = "diff previous",
		},
	},
	T = { "<cmd>TagbarToggle<CR>", "tag bar" },
	t = {
		name = "Toggle",
		f = { "<cmd> ToggleTerm direction=float <CR>", "terminal" },
		t = { "<cmd> ToggleTerm direction=tab <CR>", "terminal(t)" },
		v = { "<cmd> ToggleTerm direction=vertical size=50<CR>", "terminal(v)" },
		h = { "<cmd> ToggleTerm direction=horizontal <CR>", "terminal(h)" },
		s = { "<cmd>set hlsearch!<CR>", "highlight" },
		N = { "<cmd>set nu!<CR>", "number line" },
		n = { "<cmd>set rnu!<CR>", "relative number" },
		S = { "<cmd>lua _HTOP_TOGGLE()<CR>", "system view" },
		D = { "<cmd>lua _NCDU_TOGGLE()<CR>", "disk view" },
		R = { "<cmd>lua _RANGER_TOGGLE()<CR>", "ranger" },
		O = "onedark theme swap",
	},
	s = {
		name = "Session",
		l = { "<cmd>SessionManager load_last_session<CR>", "load last session" },
		d = { "<cmd> SessionManager load_current_dir_session<CR>", "load current dir session" },
		L = { "<cmd> SessionManager load_session<CR>", "load session" },
		D = { "<cmd> SessionManager delete_session<CR>", "delete session" },
		s = { "<cmd> SessionManager save_current_session<CR>", "save session" },
	},
	b = {
		name = "Buffer",
		g = { ":BufferLineGoToBuffer ", "goto" },
		p = { "<cmd>BufferLineTogglePin<CR>", "pin" },
		t = { "<cmd>BufferLinePick<CR>", "pick" },
		d = { "<cmd>BufferLinePickClose<CR>", "delete (choose)" },
		c = { "<cmd>bdelete<CR>", "close" },
		s = {
			name = "Sort",
			d = { "<cmd>BufferLineSortByDirectory<CR>", "directory" },
			e = { "<cmd>BufferLineSortByExtension<CR>", "extension" },
			r = { "<cmd>BufferLineSortByRelativeDirectory<CR>", "relative directory" },
			t = { "<cmd>BufferLineSortByTabs<CR>", "tabs" },
		},
		C = {
			name = "Close(s)",
			l = { "<cmd>BufferLineCloseRight<CR>", "right" },
			h = { "<cmd>BufferLineCloseLeft<CR>", "left" },
		},
	},
	v = {
		name = "view",
		s = { "<cmd> lua require('telescope.builtin').spell_suggest()<CR>", "spell suggest"},
		r = { "<cmd> lua require('telescope.builtin').registers()<CR>", "registers"},
		k = { "<cmd> lua require('telescope.builtin').keymaps()<CR>", "keymaps"},
		h = { "<cmd> lua require('telescope.builtin').highlights()<CR>", "highlights"},
		a = { "<cmd> lua require('telescope.builtin').autocommands()<CR>", "autocommands"},
		q = { "<cmd> lua require('telescope.builtin').quickfix()<CR>", "quickfix"},
		Q = { "<cmd> lua require('telescope.builtin').quickfixhistory()<CR>", "quickfix history"},
		c = { "<cmd> lua require('telescope.builtin').command_history()<CR>", "command history"},
		C = { "<cmd> lua require('telescope.builtin').commands()<CR>", "command"},
		m = { "<cmd> lua require('telescope.builtin').man_pages()<CR>", "man pages"},
		b = { "<cmd> lua require('telescope.builtin').buffers()<CR>", "buffers"},
		f = { "<cmd> lua require('telescope.builtin').filetypes()<CR>", "setup filetype"},
		t = { "<cmd> lua require('telescope.builtin').tags()<CR>", "ctags"},
		j = { "<cmd> lua require('telescope.builtin').jumplist()<CR>", "jumplist"},
		n = { "<cmd> lua require('telescope').extensions.notify.notify()<CR>", "notify history"},
	},
	["<leader>"] = {
		name = "EasyMotion",
		w = { "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", "word"},
		a = { "<cmd>lua require'hop'.hint_words()<cr>", "all"},
		l = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "line"},
		F = { "<cmd>lua require'hop'.hint_patterns()<cr>", "patterns (all)"},
		f = { "<cmd>lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "patterns"},
	},
	l = {
		name = "Lsp",
		e = "diagnostic open float",
		q = "diagnostic setloclist",
		w = {
			name = "workspace folder",
			a = "add",
			r = "remove",
			l = "list",
		},
		D = "type defination",
		r = {
			name = "Rename",
			n = "buffer",
		},
		c = {
			name = "code",
			a = "action",
		},
		f = "formatting",
	},
}, { prefix = "<leader>" })

wk.register({
	d = "lsp definition",
	D = "lsp decalaration",
}, { prefix = "]" })

wk.register({
	r = "lsp firmatting",
	D = "lsp decalaration",
	d = "lsp difinition",
}, { prefix = "g" })


 require("which-key").setup {
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
		separator = "|", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = '<c-d>', -- binding to scroll down inside the popup
		scroll_up = '<c-u>', -- binding to scroll up inside the popup
	},
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 25, -- spacing between columns
		align = "center", -- align columns left, center or right
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

-- background color : black
vim.cmd('highlight WhichKeyFloat cterm=bold ctermbg=12 ctermfg=7')
