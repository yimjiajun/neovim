
function _NOTIFY_SAMPLE()
	local plugin = "R - Info"
	vim.notify([[Error Testing ]], "error", {
			title = plugin,
			on_open = function()
				vim.notify([[Neovim x Richard]], vim.log.levels.WARN, {
					title = plugin,
				})
				local timer = vim.loop.new_timer()
				timer:start(2000, 0, function()
				vim.notify( [[searching os ...]] , "info", {
						title = plugin,
						timeout = 3000,
						on_close = function()
							local os_name
							if vim.fn.has('win32') == 1 then
								os_name =[[Window]]
							elseif vim.fn.has('macunix') == 1 then
								os_name = [[Macintosh]]
							else
								os_name = [[Linux]]
							end
							vim.notify(os_name, nil, { title = 'Oh My OS',})
							vim.notify([[Sayonara !]], 1, { title = 'See Ya' })
						end,
		  })
		end)
	  end,
})
end

function git_view_open_tjps()
	local notify_level = 'info'
	local notify_timeout = 5000
	vim.notify([[Ours]], notify_level,
		{ title = [[Keys: leader + 'c' + 'o']], timeout=notify_timeout })
	vim.notify([[Base]], notify_level,
		{ title = [[Keys: leader + 'c' + 'b']], timeout=notify_timeout })
	vim.notify([[Their]], notify_level,
		{ title = [[Keys: leader + 'c' + 't']], timeout=notify_timeout })
	vim.notify([[All]], notify_level,
		{ title = [[Keys: leader + 'c' + 'a']], timeout=notify_timeout})
	vim.notify([[Delete conflicts]], notify_level,
		{ title = [[Keys: 'd' + 'k']], timeout = notify_timeout,
			on_close = function()
				vim.notify([['g'+'ctrl'+'x'\nSwap layout display]], notify_level,
					{ title = [[Purpose : Merge tool]], timeout=notify_timeout,
						on_close = function()
							vim.notify([[Close Diff View]], notify_level,
								{ title = [[Keys: 'leader' + 'g' + 'C']], timeout = notify_timeout})
						end,
					})
			end,
	})
end

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local htop = Terminal:new({ cmd = "htop", direction = "float", hidden = true })
local ncdu = Terminal:new({ cmd = "ncdu", direction = "float", hidden = true })

function _LAZYGIT_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		lazygit:toggle()
	else
		vim.notify(
			"\tNot available.\n\tOnly supported in UNIX",
			vim.log.levels.ERROR,
			{ title = 'lazygit - gui terminal git' }
		)
	end
end

function _HTOP_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		htop:toggle()
	else
		vim.notify(
			"\tNot available.\n\tOnly supported in UNIX",
			vim.log.levels.ERROR,
			{ title = 'htop - interactive process viewer' }
		)
	end
end

function _NCDU_TOGGLE()
	if (vim.bo.fileformat:upper() == 'UNIX') then
		ncdu:toggle()
	else
		vim.notify(
			"\tNot available.\n\tOnly supported in UNIX",
			vim.log.levels.ERROR,
			{ title = 'ncdu - NCurese disk usage' }
		)
	end
end

local wk = require("which-key")

function ignore_type(type)
	return {"**/*", type}
end

function kconfig_type(type)
	return {"**/Kconfig", "*.conf", type}
end

function c_type(type)
	return {"*.c", "*.h", type}
end

wk.register({
	e = { "<cmd> NvimTreeToggle <CR>", " explore" },
	E = { "<cmd> NvimTreeFindFile <CR>", " explore file location" },
	T = { "<cmd> TagbarToggle <CR>", " tag bar" },
	f = { name = "Find", -- optional group name
		a = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search all', glob_pattern=ignore_type([[!.*]])}) <CR>", "live grep"},
		A = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search all (+ hidden)', glob_pattern=[[**/*]]})<CR>", "live grep (+ hidden)"},
		w = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search word', default_text=vim.fn.expand('<cword>'), glob_pattern=ignore_type([[!.*]])})<CR>", "search word"},
		W = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search word (+ hidden)', default_text=vim.fn.expand('<cword>'), glob_pattern=[[**/*]]})<CR>", "search word (+ hidden)"},
		c = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='.c', default_text=vim.fn.expand('<cword>'), glob_pattern=[[**/*.c]]})<CR>", "c source"},
		C = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='.c + .h', default_text=vim.fn.expand('<cword>'), glob_pattern=c_type()})<CR>", "c source + header"},
		k = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='kconfig + .conf', default_text=vim.fn.expand('<cword>'), glob_pattern=kconfig_type()})<CR>", "kconfig and .conf"},
		d = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='dts + dtsi', glob_pattern=[[**/*.dts*]], default_text=vim.fn.expand('<cword>')})<CR>", "device tree structure"},
		h = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='header', glob_pattern=[[*.h]], default_text=vim.fn.expand('<cword>')})<CR>", "header"},
		b = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='build/', glob_pattern=[[**/build/*]], default_text=vim.fn.expand('<cword>')})<CR>", "build folder"},
		['?'] = { ": lua require('telescope.builtin').live_grep({prompt_title='customize search', glob_pattern=[[$PARAM_1]], cwd=[[$PARAM_2]]})", "customize search"},
		i = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search word', default_text=vim.fn.expand('<cword>')})<CR>", "live grep"},
		F = { "<cmd> lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>", "* files"},
		f = { "<cmd> lua require('telescope.builtin').find_files()<CR>", "files"},
		o = { "<cmd> lua require('telescope.builtin').oldfiles()<CR>", "recently opened"},
		S = { "<cmd> lua require('telescope.builtin').search_history()<CR>", "search histroy"},
		j = { "<cmd> lua require('telescope.builtin').jumplist()<CR>", "jumplist"},
		q = { "<cmd> lua require('telescope.builtin').quickfix({show_line = false, trim_text = true, fname_width = 80}) <CR>", "quickfix"},
		Q = { "<cmd> lua require('telescope.builtin').quickfixhistory({show_line = true, trim_text = false}) <CR>", "quickfix history"},
		r = { "<cmd> lua require('telescope.builtin').registers() print[[Ctrl+e to edit contents]] <CR>", "registers"},
		m = { "<cmd> lua require('telescope.builtin').marks() <CR>", "marks"},
		s = {	name = "Specific",
			c = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='.c', glob_pattern=[[**/*.c]]})<CR>", "c source"},
			C = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='.c + .h', glob_pattern=c_type()})<CR>", "c source + header"},
			k = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='kconfig + .conf', glob_pattern=kconfig_type()})<CR>", "kconfig and .conf"},
			d = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='dts + dtsi', glob_pattern=[[**/*.dts*]]})<CR>", "device tree structure"},
			h = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='header', glob_pattern=[[*.h]]})<CR>", "header"},
			b = { "<cmd> lua require('telescope.builtin').live_grep({prompt_title='build/', glob_pattern=[[**/build/*]]})<CR>", "build folder"},
		},
	},
	c = { name = "cscope",
		a = { "<cmd> cs find a <cword><CR>", "(symbols) - assignment to this symbol"},
		s = { "<cmd> cs find s <cword><CR>", "(symbols) - all refrences"},
		g = { "<cmd> cs find g <cword><CR>", "(globals) - global definition(s)"},
		c = { "<cmd> cs find c <cword><CR>", "(calls) - all calls to the function name"},
		t = { "<cmd> cs find t <cword><CR>", "(text) - all instances of the text"},
		d = { "<cmd> cs find d <cword><CR>", "(called) - find functions that function"},
		e = { "<cmd> cs find e <cword><CR>", "(egrep) - search for the word"},
		f = { "<cmd> cs find f <cfile><CR>", "(files) - open the filename"},
		i = { "<cmd> cs find i <cfile><CR>", "(includes) - find files that include the filename"},
	},
	g = { name = "Git",
		s = { name = "Stage",
			s = "hunk",
			S = "buffer",
			u = "undo hunk",
			r = "reset hunk",
			R = "reset buffer",
			p = "preview hunk",
		},
		b = { name = "Blame",
			a = "details",
			b = "toggle",
		},
		t = { name = "Toggle",
			d = "deleted contents",
			w = "diff contents",
			s = "side signs",
			l = "contents line",
			b = "number line",
			t = { "<cmd> lua _LAZYGIT_TOGGLE() <CR>", "lazygit" },
		},
		d = { name = "Diff",
			d = "this",
			p = "previous",
			a = { "<cmd> DiffviewOpen <CR>", "all" },
		},
		g = { "<cmd> lua require('telescope.builtin').git_status()<CR>", "status" },
		l = { "<cmd> lua require('telescope.builtin').git_commits()<CR>", "commit logs" },
		L = { "<cmd> DiffviewFileHistory <CR>", "commit details" },
		m = { "<cmd> DiffviewOpen <CR> <cmd> lua git_view_open_tips() <CR>", "merge" },
		C = { "<cmd> DiffviewClose <CR>", "close - diff view" },
		v = { "<cmd> DiffviewToggleFiles <CR>", "toggle - diff view" },
		V = { "<cmd> DiffviewFocusFiles <CR>", "focus - diff view" },
	},
	t = {
		name = "Toggle",
		f = { "<cmd> ToggleTerm direction=float <CR>", " float" },
		t = { "<cmd> ToggleTerm direction=tab <CR>", " tab" },
		v = { "<cmd> ToggleTerm direction=vertical size=50<CR>", " vertical" },
		h = { "<cmd> ToggleTerm direction=horizontal <CR>", " horizontal" },
		N = { "<cmd> set nu!<CR>", " number line" },
		n = { "<cmd> set rnu!<CR>", " relative number" },
		S = { "<cmd> lua _HTOP_TOGGLE()<CR>", " system view" },
		D = { "<cmd> lua _NCDU_TOGGLE()<CR>", " disk view" },
		i = { "<cmd> IndentBlanklineToggle<CR>", " indent" },
		s = { "<cmd> set spell! <CR>", "暈 spelling" },
		C = {
			name = "Create",
			t = { "<cmd> !ctags -R . <CR>", "  cTags" },
			c = { "<cmd> !cscope -bqRv <CR>", "識  cscope" },
		},
		q = { "<cmd> cclose <CR>", " quickfix (close)" },
		Q = { "<cmd> copen <CR>", " quickfix (open)" },
	},
	s = {
		name = "Session",
		l = { "<cmd> SessionManager load_last_session<CR>", "load last session" },
		d = { "<cmd> SessionManager load_current_dir_session<CR>", "load current dir session" },
		L = { "<cmd> SessionManager load_session<CR>", "load session" },
		D = { "<cmd> SessionManager delete_session<CR>", "delete session" },
		s = { "<cmd> SessionManager save_current_session<CR>", "save session" },
	},
	b = { name = "Buffer",
		b = { "<cmd> lua require('telescope.builtin').buffers() <CR>", "buffers"},
		g = { ":BufferLineGoToBuffer ", "goto" },
		p = { "<cmd> BufferLineTogglePin<CR>", "pin" },
		t = { "<cmd> BufferLinePick<CR>", "pick" },
		d = { "<cmd> BufferLinePickClose<CR>", "delete (choose)" },
		c = { "<cmd> bdelete<CR>", "close" },
		s = { name = "Sort",
			d = { "<cmd> BufferLineSortByDirectory<CR>", "directory" },
			e = { "<cmd> BufferLineSortByExtension<CR>", "extension" },
			r = { "<cmd> BufferLineSortByRelativeDirectory<CR>", "relative directory" },
			t = { "<cmd> BufferLineSortByTabs<CR>", "tabs" },
		},
		C = { name = "Close(s)",
			l = { "<cmd> BufferLineCloseRight<CR>", "right" },
			h = { "<cmd> BufferLineCloseLeft<CR>", "left" },
		},
	},
	v = { name = "view",
		s = { "<cmd> lua require('telescope.builtin').spell_suggest() <CR>", "spell suggest"},
		k = { "<cmd> lua require('telescope.builtin').keymaps() <CR>", "keymaps"},
		h = { "<cmd> lua require('telescope.builtin').highlights() <CR>", "highlights"},
		a = { "<cmd> lua require('telescope.builtin').autocommands() <CR>", "autocommands"},
		c = { "<cmd> lua require('telescope.builtin').command_history() <CR>", "command history"},
		C = { "<cmd> lua require('telescope.builtin').commands() <CR>", "command"},
		f = { "<cmd> lua require('telescope.builtin').filetypes() <CR>", "setup filetype"},
		t = { "<cmd> lua require('telescope.builtin').tags() <CR>", "ctags"},
		n = { "<cmd> lua require('telescope').extensions.notify.notify() <CR>", "notify history"},
		['.'] = { "<cmd> lua _NOTIFY_SAMPLE() <CR>", "notify ami EC"},
	},
	["<leader>"] = { name = "EasyMotion",
		w = { "<cmd> lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", "word"},
		a = { "<cmd> lua require'hop'.hint_words()<cr>", "all"},
		l = { "<cmd> lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "line"},
		F = { "<cmd> lua require'hop'.hint_patterns()<cr>", "patterns (all)"},
		f = { "<cmd> lua require'hop'.hint_patterns({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "patterns"},
	},
}, { prefix = "<leader>" })

wk.register({
	g = { name = "Git",
		s = { name = "Stage",
			s = "stage to hunk",
			r = "reset selected hunk",
		},
	},
}, { mode = 'v', prefix = "<leader>" })

wk.register({
	t = "tab next",
	T = "tab previous",
	x = "open url link",
}, { mode = 'n', prefix = "g" })

if vim.g.custom.lsp_support == 1 then

	wk.register({
		l = { name = "Lsp",
			e = "diagnostic open float",
			q = "diagnostic setloclist",
			w = {
				name = "workspace folder",
				a = "add",
				r = "remove",
				l = "list",
			},
			r = "rename buffer",
			c = "code action",
			f = "formatting",
		},
	}, { prefix = "<leader>" })

	wk.register({
		d = "lsp next diagnostic",
		D = "lsp previous diagnostic",
	}, { prefix = "]" })

	wk.register({
		r = "lsp reference",
		D = "lsp decalaration",
		d = "lsp definition",
		i = "lsp implementation",
		y = "lsp type-definition",
		p = { name = "LSP Preview",
			r = { "<cmd> lua require('goto-preview').goto_preview_references() <CR>", "reference"},
			d = { "<cmd> lua require('goto-preview').goto_preview_definition() <CR>", "definition"},
			i = { "<cmd> lua require('goto-preview').goto_preview_implementation() <CR>", "implementation"},
			y = { "<cmd> lua require('goto-preview').goto_preview_type_definition() <CR>", "type definition"},
			c = { "<cmd> lua require('goto-preview').close_all_win() <CR>", "close all window"},
		},
	}, { prefix = "g" })

else -- if vim.g.custom.lsp_support == 1 then

	wk.register({
		d = "lsp definition",
		r = "lsp reference",
		i = "lsp implementation",
		y = "lsp type-definition",
		p = { name = "lsp preview",
			d = { "<CMD> CocCommand fzf-preview.CocDefinition <CR>", "definition"},
			r = { "<CMD> CocCommand fzf-preview.CocReferences <CR>", "refrences"},
			i = { "<CMD> CocCommand fzf-preview.CocImplementations <CR>", "implementation"},
			y = { "<CMD> CocCommand fzf-preview.CocTypeDefinition <CR>", "type-definition"},
			D = { name = "diagnostics",
				D = { "<CMD> CocCommand fzf-preview.CocDiagnostics <CR>", "diagnostics"},
				d = { "<CMD> CocCommand fzf-preview.CocCurrentDiagnostics <CR>", "current diagnostics"},
			},
			o = { "<CMD> CocCommand fzf-preview.CocOutline <CR>", "outline"},
		},
	}, { prefix = "g" })

	wk.register({
		l = {
			c = {
				name = "Coc",
				a = {
					name = "Action",
					a = "applying code-action (selected region)",
					c = "applying code-action (current buffer)",
					f = "applying code-action (current line)",
					l = "run code lens action (current line)",
					n = "symbol renaming",
					s = "formatting selected code",
				},
				l = {
					name = "Lists",
					a = "all diagnostics",
					e = "manage external",
					c = "show commands",
					o = "find symbol of current document",
					s = "search workspace symbols",
					j = "do definition action for next item",
					k = "do default action for previous item",
					p = "resume latest coc list",
				},
			},
		},
	}, { prefix = "<leader>" })

	wk.register({
		g = "previous coc diagnostic",
	}, { prefix = "[" })

	wk.register({
		g = "next coc diagnostic",
	}, { prefix = "]" })
end

