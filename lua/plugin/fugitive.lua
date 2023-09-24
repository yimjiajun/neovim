local function fugitive_setup_global_variable()
	vim.g.vim_git = "Git"
end

local function fugitive_setup_autocmd()
vim.api.nvim_create_augroup( "git", { clear = true })
vim.api.nvim_create_autocmd( "FileType", {
	desc = "Format git commit message",
	group = "git",
	pattern = "gitcommit",
	callback = function()
		vim.cmd("setlocal spell")
		vim.cmd("setlocal wrap")
		vim.cmd("setlocal expandtab")
		vim.cmd("setlocal norelativenumber")
		vim.cmd("setlocal nonumber")
	end,
})

vim.api.nvim_create_autocmd( "FileType", {
	desc = "Fromat common git",
	group = "git",
	pattern = "git",
	callback = function()
		vim.cmd("setlocal nowrap")
		vim.cmd("setlocal norelativenumber")
		vim.cmd("setlocal nonumber")
	end,
})
end

fugitive_setup_global_variable()
fugitive_setup_autocmd()

local ret = {}

return ret
