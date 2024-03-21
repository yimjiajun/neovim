local function setup()
	local null_ls = require("null-ls")
	local f = null_ls.builtins.formatting
	local d = null_ls.builtins.diagnostics
	local c = null_ls.builtins.completion
	local a = null_ls.builtins.code_actions
	local h = null_ls.builtins.hover

	null_ls.setup({
		sources = {
			f.clang_format,
			f.cmake_format,
			f.prettier,
			f.stylua,
			d.cmake_lint,
			d.pylint,
			c.tags,
			a.gitsigns,
			a.gitrebase,
			h.dictionary,
			h.printenv,
		},
	})
end

return {
	Setup = setup,
}
