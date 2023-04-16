local M

local function get_orgmode_remote_path()
	local path
	if vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1 then
		if vim.fn.isdirectory("/run/wsl") == 1 then
			path = vim.fn.expand("/mnt/c/Users/**/Dropbox")
		else
			path = vim.fn.expand("$HOME/Dropbox")
		end
	elseif vim.fn.has('win32') == 1 then
		path = vim.fn.expand("C:\\Users\\**\\Dropbox")
	end
	return path
end

local remote_path = get_orgmode_remote_path()
local usr_org_file = remote_path .. '/' .. vim.fn.expand("org/refile.org")
local usr_org_agenda_files = { remote_path .. '/' .. '**/*' }

M = {
	org_agenda_files = usr_org_agenda_files,
	org_default_notes_file = usr_org_file,
}

if pcall(require, "which-key") then
	vim.api.nvim_create_augroup("orgmode", { clear = true })

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "Append orgmode keybindings to which-key",
		group = "orgmode",
		pattern = "org",
		callback = function()
			local wk = require("which-key")

			wk.register({
				['?'] = "org mode help",
			}, { prefix = "g" })

			wk.register({
				o = { name = "Orgmode",
					a = { "Open agenda prompt" },
					c = { "Open capture prompt" },
				},
			}, { prefix = "<leader>" })

		end,
	})
end

require('orgmode').setup_ts_grammar()
require('orgmode').setup(M)

return M
