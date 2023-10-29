local function setup()
	local function setup_keymap()
		vim.api.nvim_set_keymap('n', "<leader>tf", ":ToggleTerm direction=float <CR>", { silent = true, noremap = true })
		vim.api.nvim_set_keymap('n', "<leader>ts", ":ToggleTerm direction=horizontal<CR>", { silent = true, noremap = true })
		vim.api.nvim_set_keymap('n', "<leader>tv", ":ToggleTerm direction=vertical<CR>", { silent = true, noremap = true })
	end

	local function setup_autocmd()
		-- vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
		vim.api.nvim_create_augroup( "toggleterm", { clear = true })
		vim.api.nvim_create_autocmd( "FileType", {
			desc = "Hide Toggle Term",
			group = "toggleterm",
			pattern = "toggleterm",
			callback = function()
				local current_buf = vim.api.nvim_get_current_buf()
				local keymap = vim.api.nvim_buf_set_keymap
				local opts = { noremap = true, silent = true }

				keymap(current_buf, 't', 'jkl', '<c-\\><c-n>', opts)
				keymap(current_buf, 't', 'lkj', '<c-\\><c-n><cmd>ToggleTerm<CR>', opts)
			end,
		})
	end

	require("toggleterm").setup{
		-- size can be a number or function which is passed the current terminal
		size = function(term)-- 20 | function(term)
			if term.direction == "horizontal" then
				return 10
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		-- open_mapping = [[<c-\>]],
		-- on_open = fun(t: Terminal), -- function to run when the terminal opens
		-- on_close = fun(t: Terminal), -- function to run when the terminal closes
		-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string)
			-- callback for processing output on stdout
		-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string)
			-- callback for processing output on stderr
		-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string)
			-- function to run when terminal process exits
		hide_numbers = true, -- hide the number column in toggleterm buffers
		shade_filetypes = {},
		highlights = {
			-- highlights which map to a highlight group name and a table of it's values
			-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
			Normal = {
				link = "NormalFloat",
			},
			NormalFloat = {
				link = 'NormalFloat'
			},
			FloatBorder = {
				link = "NormalFloat",
			},
		},
		shade_terminals = true,
		shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
		persist_size = true,
		persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
		direction = 'float',--'vertical' | 'horizontal' | 'tab' | 'float',
		close_on_exit = true, -- close the terminal window when the process exits
		shell = vim.o.shell, -- change the default shell
		auto_scroll = true, -- automatically scroll to the bottom on terminal output
		-- This field is only relevant if direction is set to 'float'
		float_opts = {
			-- The border key is *almost* the same as 'nvim_open_win'
			-- see :h nvim_open_win for details on borders however
			-- the 'curved' border is a custom border type
			-- not natively supported but implemented in this plugin.
			--'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
			border = 'curved',
			-- like `size`, width and height can be a number or function which is passed the current terminal
			-- width = <value>,
			-- height = 50,
			-- winblend = 20,
		},
		winbar = {
			enabled = false,
			name_formatter = function(term) --  term: Terminal
				return term.name
			end
		},
	}

	vim.cmd("command! -nargs=1 TermCmd lua require'toggleterm'.exec(<q-args>)")

	if vim.g.vim_git == "!git"  then
		vim.g.vim_git = "TermCmd git"
	end

	setup_keymap()
	setup_autocmd()
end

return {
	Setup = setup,
}
