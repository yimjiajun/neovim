local function session()
	vim.api.nvim_create_augroup("session", { clear = true })

	vim.api.nvim_create_autocmd( "VimLeavePre", {
		desc = "Save Session Before Leave Neovim",
		group = "session",
		pattern = "*.*",
		callback = function()
			require("features.session").Save()
		end,
	})
end

local function statusline()
	vim.api.nvim_create_augroup("statusline", { clear = true })

	vim.api.nvim_create_autocmd( "BufRead", {
		desc = "Refresh statusline",
		group = "statusline",
		pattern = "*",
		callback = function()
			require('config.function').SetStatusline()
		end,
	})
end

local function format()
	vim.api.nvim_create_augroup( "format", { clear = true })

	vim.api.nvim_create_autocmd("InsertLeave", {
		desc = "Killing whitespace trailing",
		group = "format",
		pattern = "*",
		callback = function()
			if vim.fn.expand('%:p') == '' or vim.bo.filetype == '' then
				return
			end

			vim.cmd([[s/\s\+$//e]])
			vim.fn.setpos('.', { 0,
				vim.api.nvim_win_get_cursor(0)[1],
				vim.api.nvim_win_get_cursor(0)[2] + 1,
				0}
			)
		end,
	})

	vim.api.nvim_create_autocmd( "BufWritePre", {
		desc = "Killing DOS new line",
		group = "format",
		pattern = "*",
		callback = function()
			if vim.fn.expand('%:p') == '' or vim.bo.filetype == '' then
				return
			end

			vim.cmd([[%s/\r\+$//e]])
		end,
	})
end

local function cursor()
	vim.api.nvim_create_augroup("cursor", { clear = true })

	vim.api.nvim_create_autocmd("WinEnter", {
		desc = "Enable cursor line",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.cmd('set cursorline')
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		desc = "Enable cursor line",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.cmd('set cursorline')
		end,
	})

	vim.api.nvim_create_autocmd("WinEnter", {
		desc = "Enable cursor line",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.cmd('set cursorline')
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		desc = "Disable cursor line",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.cmd('set nocursorline')
		end,
	})

	vim.api.nvim_create_autocmd("WinLeave", {
		desc = "Disable cursor line",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.cmd('set nocursorline')
		end,
	})

	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = "Flash the part being yank",
		group = "cursor",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = 'Visual' })
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		desc = "Release <Enter> keymap feature",
		group = "cursor",
		pattern = "qf",
		callback = function()
			vim.api.nvim_buf_set_keymap(0, 'n', '<CR>',
				'<CR>', { noremap = true, silent = true })
		end,
	})
end

local function programming()
	vim.api.nvim_create_augroup("programming", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		desc = "C",
		group = "programming",
		pattern = "c",
		callback = function()
			vim.cmd('setlocal cindent')
			vim.cmd('setlocal softtabstop=4')
			vim.cmd('setlocal tabstop=4')
			vim.cmd('setlocal shiftwidth=4')
			vim.cmd('setlocal expandtab')
		end,
	})

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "Cpp",
		group = "programming",
		pattern = "cpp",
		callback = function()
			vim.cmd('setlocal cindent')
			vim.cmd('setlocal softtabstop=4')
			vim.cmd('setlocal tabstop=4')
			vim.cmd('setlocal shiftwidth=4')
			vim.cmd('setlocal expandtab')
		end,
	})

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "markdown",
		group = "programming",
		pattern = "markdown",
		callback = function()
			vim.cmd('setlocal softtabstop=2')
			vim.cmd('setlocal tabstop=2')
			vim.cmd('setlocal shiftwidth=2')
			vim.cmd('setlocal expandtab')
			vim.cmd('setlocal spell')
		end,
	})

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "python",
		group = "programming",
		pattern = "py",
		callback = function()
			vim.cmd('setlocal softtabstop=2')
			vim.cmd('setlocal tabstop=2')
			vim.cmd('setlocal shiftwidth=2')
			vim.cmd('setlocal expandtab')
		end,
	})

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "lua",
		group = "programming",
		pattern = "lua",
		callback = function()
			vim.cmd('setlocal softtabstop=2')
			vim.cmd('setlocal tabstop=2')
			vim.cmd('setlocal shiftwidth=2')
		end,
	})
end

local function terminal()
	vim.api.nvim_create_augroup("terminal", { clear = true })

	vim.api.nvim_create_autocmd("TermOpen", {
		desc = "Terminal",
		group = "terminal",
		callback = function()
			vim.cmd('setlocal nonumber')
			vim.cmd('setlocal norelativenumber')
		end
	})
end

local function file()
	vim.cmd([[
		augroup Binary
		autocmd!
		autocmd BufReadPre *.bin let &bin=1
		autocmd BufReadPost *.bin if &bin | %!xxd
		autocmd BufReadPost *.bin set ft=xxd | endif
		autocmd BufWritePre *.bin if &bin | %!xxd -r
		autocmd BufWritePre *.bin endif
		autocmd BufWritePost *.bin if &bin | %!xxd
		autocmd BufWritePost *.bin set nomod | endif
		augroup END
	]])

	vim.cmd([[
		let g:large_file = 500 * 1048" 500KB

		" Set options:
		"   eventignore+=FileType (no syntax highlighting etc
		"   assumes FileType always on)
		"   noswapfile (save copy of file)
		"   bufhidden=unload (save memory when other file is viewed)
		"   buftype=nowritefile (is read-only)
		"   undolevels=-1 (no undo possible)
		au BufReadPre *
			\ let f=expand("<afile>") |
			\ if getfsize(f) > g:large_file |
			\ set eventignore+=FileType |
			\ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
			\ if getfsize(f) <= (1048*1048*1048) |
			\ if getfsize(f) < (1048*1048) |
			\ echo "large file :" (getfsize(f)/1048)"KB" |
			\ else |
			\ echo "large file :" (getfsize(f)/1048/1048)(getfsize(f)/1048%1000)"MB" |
			\ endif |
			\ else |
			\ echo "large file :" (getfsize(f)/1048/1048/1048)(getfsize(f)/1048/1048%1000)"GB" |
			\ endif |
			\ else |
			\ set eventignore-=FileType |
			\ endif
	]])
end

local function package()
	vim.api.nvim_create_augroup("package", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		desc = "setup git wrapper, if vim-fugitive package exists",
		group = "package",
		callback = function()
			if vim.fn.exists(":Git") then
				vim.g.vim_git = "Git"
			else
				vim.g.vim_git = "git"
			end
		end,
	})
end

local function setup()
	session()
	statusline()
	format()
	cursor()
	programming()
	terminal()
	file()
	package()
end

return {
	Setup = setup,
	Session = session,
	Statusline = statusline,
	Format = format,
	Cursor = cursor,
	Programming = programming,
	Terminal = terminal,
	File = file,
	Package = package,
}
