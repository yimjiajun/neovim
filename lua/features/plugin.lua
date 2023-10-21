local function native_package_install()
	local packages = {
		{ name = "vim-dispatch",
			url = [[https://github.com/tpope/vim-dispatch.git]]
		},
		{ name = "vim-fugitive",
			url = [[https://github.com/tpope/vim-fugitive.git]]
		}
	}
	local d = vim.fn.has('win32') ~= 0 and "\\" or "/"
	local path = vim.fn.stdpath('data') .. d .. 'site' .. d .. 'pack' .. d .. 'jun' .. d .. 'start'

	if vim.fn.isdirectory(path) == 0 then
		vim.api.nvim_echo({ { "package: create package directory ... " .. path } }, false, {})
		vim.fn.mkdir(path, "p")
	end

	for _, v in ipairs(packages) do
		local pack_dir = path .. d .. v.name
		if vim.fn.isdirectory(pack_dir) == 0 then
			vim.api.nvim_echo({ { "package: download " .. v.name } }, false, {})
			vim.fn.system("git clone " .. v.url .. " " .. pack_dir)
		end
	end
end

local function setup()
		native_package_install()
end

return {
	Setup = setup,
}
