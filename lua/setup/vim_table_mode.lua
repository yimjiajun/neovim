local ret = {}

local function setup_table_delimiter()
	vim.api.nvim_create_augroup("vim_table_delimiter", { clear = true })

	vim.api.nvim_create_autocmd( "filetype", {
		desc = "setup org-mode table delimiter",
		group = "vim_table_delimiter",
		pattern = "org",
		callback = function()
			vim.g.table_mode_corner = "+"
		end,
	})

	vim.api.nvim_create_autocmd( "filetype", {
		desc = "setup markdown table delimiter",
		group = "vim_table_delimiter",
		pattern = "markdown",
		callback = function()
			vim.g.table_mode_corner = "|"
		end,
	})

end

setup_table_delimiter()

return ret
