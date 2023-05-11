vim.api.nvim_create_augroup( "session", { clear = true })
vim.api.nvim_create_autocmd( "VimLeavePre", {
	desc = "Save Session Before Leave Neovim",
	group = "session",
	pattern = "*.*",
	callback = function()
		require("config.function").Session("save")
	end,
})

vim.api.nvim_create_augroup( "format", { clear = true })

vim.api.nvim_create_autocmd( "BufWritePre", {
	desc = "Killing whitespace trailing",
	group = "format",
	pattern = "*",
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
})

vim.api.nvim_create_autocmd( "BufWritePre", {
	desc = "Killing DOS new line",
	group = "format",
	pattern = "*",
	callback = function()
		vim.cmd([[%s/\r\+$//e]])
	end,
})

vim.api.nvim_create_autocmd( "Syntax", {
	desc = "Display whitespace trailing",
	group = "format",
	pattern = "*",
	callback = function()
		vim.cmd([[match ExtraWhitespace /\s\+$\| \+\ze\t/]])
		vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
	end,
})

vim.api.nvim_create_augroup( "cursor", { clear = true })

vim.api.nvim_create_autocmd( "InsertLeave, WinEnter", {
	desc = "Enable cursor line",
	group = "cursor",
	pattern = "*",
	callback = function()
		vim.cmd('set cursorline')
	end,
})

vim.api.nvim_create_autocmd( "WinEnter", {
	desc = "Enable cursor line",
	group = "cursor",
	pattern = "*",
	callback = function()
		vim.cmd('set cursorline')
	end,
})

vim.api.nvim_create_autocmd( "InsertEnter", {
	desc = "Disable cursor line",
	group = "cursor",
	pattern = "*",
	callback = function()
		vim.cmd('set nocursorline')
	end,
})

vim.api.nvim_create_autocmd( "WinLeave", {
	desc = "Disable cursor line",
	group = "cursor",
	pattern = "*",
	callback = function()
		vim.cmd('set nocursorline')
	end,
})

vim.api.nvim_create_augroup( "programming", { clear = true })
vim.api.nvim_create_autocmd( "FileType", {
	desc = "C",
	group = "programming",
	pattern = "c",
	callback = function()
		vim.cmd('setlocal cindent')
		vim.cmd('setlocal softtabstop=4')
		vim.cmd('setlocal tabstop=4')
		vim.cmd('setlocal shiftwidth=4')
		vim.cmd('setlocal noexpandtab')
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
		vim.cmd('setlocal noexpandtab')
	end,
})

vim.api.nvim_create_autocmd( "FileType", {
	desc = "markdown",
	group = "programming",
	pattern = "md",
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
