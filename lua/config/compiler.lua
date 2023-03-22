local prj_found = nil
local path = nil
local func = require("config.functions")

path = func.getDirWithPattern("^ecfw.-zephyr$")
if path ~= nil  then
	local build_script = 'build.sh'

	prj_found = true
	path = path .. '/' .. build_script
	vim.fs.normalize(path)

	if io.open(path) then
		vim.api.nvim_set_option('makeprg', [[cd $(west topdir)/$(west config manifest.path) && ./build.sh]])
	else
		vim.api.nvim_set_option('makeprg', [[west build -p=always -d $(west config manifest.path)/build $(west config manifest.path)]])
	end
end

vim.api.nvim_create_augroup( "compiler", { clear = true })

	if prj_found ~= true then
		vim.api.nvim_create_autocmd( "FileType", {
			desc = "GCC",
			group = "compiler",
			pattern = "c",
			callback = function()
			if not io.open(string.lower('Makefile')) then
					local bufnr = vim.api.nvim_get_current_buf()
					vim.api.nvim_buf_set_option(bufnr, 'makeprg', [[gcc % -o %:t:r && mv %:t:r /tmp/%:t:r && /tmp/%:t:r && rm /tmp/%:t:r]])
				end
			end,
		})
	end

	vim.api.nvim_create_autocmd( "FileType", {
		desc = "python",
		group = "compiler",
		pattern = "python",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_option(bufnr, 'makeprg', [[python3 %]])
		end,
	})
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "perl",
		group = "compiler",
		pattern = "perl",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_option(bufnr, 'makeprg', [[perl %]])
		end,
	})
	vim.api.nvim_create_autocmd( "FileType", {
		desc = "bash script",
		group = "compiler",
		pattern = "sh",
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_option(bufnr, 'makeprg', [[./%]])
		end,
	})
