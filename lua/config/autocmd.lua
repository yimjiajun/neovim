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
