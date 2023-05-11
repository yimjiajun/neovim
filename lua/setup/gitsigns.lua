require('gitsigns').setup {
	signs = {
		add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
		change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	},
	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
		delay = 0,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = '<author>(<author_time:%Y-%m-%d>):  <summary>',
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = 'single',
		style = 'minimal',
		relative = 'cursor',
		row = 0,
		col = 1
	},
	yadm = {
		enable = false
	},

	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
			if vim.wo.diff then return ']c' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, {expr=true})

		map('n', '[c', function()
			if vim.wo.diff then return '[c' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, {expr=true})

		-- Actions
		map({'n', 'v'}, '<leader>gGss', ':Gitsigns stage_hunk<CR>')
		map({'n', 'v'}, '<leader>gGsr', ':Gitsigns reset_hunk<CR>')
		map('n', '<leader>gGsS', gs.stage_buffer)
		map('n', '<leader>gGsu', gs.undo_stage_hunk)
		map('n', '<leader>gGsR', gs.reset_buffer)
		map('n', '<leader>gGsp', gs.preview_hunk)
		map('n', '<leader>gGba', function() gs.blame_line{full=true} end)
		map('n', '<leader>gGbb', gs.toggle_current_line_blame)
		map('n', '<leader>gGdd', gs.diffthis)
		map('n', '<leader>gGdp', function() gs.diffthis('~') end)
		map('n', '<leader>gGtd', gs.toggle_deleted)
		map('n', '<leader>gGtw', gs.toggle_word_diff)
		map('n', '<leader>gGts', gs.toggle_signs)
		map('n', '<leader>gGtl', gs.toggle_linehl)
		map('n', '<leader>gGtn', gs.toggle_numhl)

		-- Text object
		map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end
}

if pcall(require, "which-key") then
	local wk = require("which-key")
	wk.register({
		G = { name = "GitSign",
			s = { name = "Stage",
				s = 'hunk',
				r = 'reset',
				S = 'buffer',
				u = 'undo',
				R = 'reset buffer',
				p = 'preview hunk',
			},
			b = { name = "Blame",
				a = 'line',
				b = 'toggle current line blame',
			},
			d = { name = "Diff",
				d = 'diffthis',
				p = 'diffthis ~',
			},
			t = { name = "Toggle",
				d = 'toggle deleted',
				w = 'toggle word diff',
				s = 'toggle signs',
				l = 'toggle linehl',
				n = 'toggle numhl',
			},
		},
	}, { prefix = "<leader>g" })
end
