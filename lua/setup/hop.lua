vim.api.nvim_create_autocmd( "VimEnter", {
	desc = "easy motion on brightness colors",
	pattern = "*",
	callback = function()
		vim.cmd('highlight HopNextKey cterm=bold ctermfg=190 guifg=#d7ff00')
		vim.cmd('highlight HopNextKey1 cterm=bold ctermfg=191 guifg=#d7ff5f')
		vim.cmd('highlight HopNextKey2 cterm=bold ctermfg=192 guifg=#d7ff87')
	end,
})
