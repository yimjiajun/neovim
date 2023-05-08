vim.api.nvim_create_augroup( "session", { clear = true })
	vim.api.nvim_create_autocmd( "VimLeavePre", {
		desc = "Save Session Before Leave Neovim",
		group = "session",
		pattern = "*",
		callback = function()
			require("config.function").Session("save")
		end,
	})
