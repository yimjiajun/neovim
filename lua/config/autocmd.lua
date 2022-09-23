vim.api.nvim_create_augroup("cursorline", { clear = true })
	vim.api.nvim_create_autocmd( "InsertEnter", {
		desc = "Disable cursor line when insert mode",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', false)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "InsertLeave", {
		desc = "Display cursor line",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', true)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "WinEnter", {
		desc = "Display cursor line",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', true)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd( "WinLeave", {
		desc = "Disable curasor display",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option('cursorline', false)
			vim.api.nvim_set_option('cursorcolumn', false)
		end,
	})
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = "Flash the part being yank",
		group = "cursorline",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = 'Visual' })
		end,
	})

vim.api.nvim_create_augroup( "extension file", { clear = true })
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "smart indent for c ",
		group = "extension file",
		pattern = "c",
		callback = function()
			vim.opt_local.cindent = true
			vim.opt_local.softtabstop = 4
			vim.opt_local.tabstop = 4
			vim.opt_local.shiftwidth = 4
			vim.opt_local.expandtab = false
		end,
	})
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "smart indent for header",
		group = "extension file",
		pattern = "cpp",
		callback = function()
			vim.opt_local.cindent = true
			vim.opt_local.softtabstop = 4
			vim.opt_local.tabstop = 4
			vim.opt_local.shiftwidth = 4
			vim.opt_local.expandtab = false
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

if (vim.fn.has('cscope') == 1) then
	if (vim.fn.filereadable('cscope.out') == 1) then
		vim.cmd('cs add cscope.out')
	end
end

if vim.fn.has('win32') == 1 then
	vim.cmd[[source $MYVIMRC/../lua/config/autocmd.vim]]
else
	vim.cmd[[source $HOME/.config/nvim/lua/config/autocmd.vim]]
end
