vim.api.nvim_create_augroup("cursorline", { clear = true })
	vim.api.nvim_create_autocmd( "InsertEnter", {
		desc = "",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', false)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "InsertLeave", {
		desc = "",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', true)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "WinEnter", {
		desc = "",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', true)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "WinLeave", {
		desc = "",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', false)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = "",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = 'Visual' })
		end,
	})

vim.api.nvim_create_augroup( "extension file", { clear = true })
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "smart indent for c and c++",
		group = "extension file",
		pattern = "c, cpp",
		callback = function()
			vim.api.nvim_set_option('cindent', true)
		end,
	})
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "smart indent for yaml",
		group = "extension file",
		pattern = "yaml",
		callback = function()
			vim.opt_local.tabstop = 2
			vim.opt_local.softtabstop = 2
			vim.opt_local.shiftwidth = 2
			vim.opt_local.expandtab = true
		end,
	})
	vim.api.nvim_create_autocmd( "BufWritePre", {
		desc = "kill trailing whitespace",
		group = "extension file",
		pattern = "*",
		callback = function()
			vim.cmd([[%s/\s\+$//e]])
		end,
	})

vim.api.nvim_create_augroup( "highlight", { clear = true })
	vim.api.nvim_create_autocmd( "Syntax", {
		desc = "whitespace trailing display",
		group = "highlight",
		pattern = "*",
		callback = function()
			vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
			-- TODO
			vim.cmd([[syn match ExtraWhitespace /\s\+$\| \+\ze\t/]])
		end,
	})
