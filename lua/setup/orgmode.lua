local M

M = {
	org_agenda_files = {'~/Public/doc/org/**/*', '~/my-orgs/**/*'},
	org_default_notes_file = '~/Public/doc/org/refile.org',
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
