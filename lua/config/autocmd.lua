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
