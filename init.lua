vim.g.custom = {
	colorscheme = {
		theme = 'gruvbox',
		transparency = false,
	},
	lsp = {
		"bashls",
		"clangd", "cmake",
		"lua_ls",
		"marksman",
		"pyright",
		"rust_analyzer",
	},
	format = {
		kill_whitespace = 1,
	},
}

if vim.g.neovide ~= nil then
	require('setup.neovide').setup()
end

local config_path = vim.fn.stdpath("config")
local config_dir = {"config", "features", "usr"}

for _, dir in ipairs(config_dir) do
	local lua_config_path = config_path .. "/lua/" .. dir
	local lua_files = vim.fn.glob(lua_config_path .. "/*.lua", false, true)

	for _, file in ipairs(lua_files) do
		local script = vim.fn.fnamemodify(file, ":t")
		local source = dir .. "." .. string.match(script, "([^.]+)")
		local status_ok, fault = pcall(require, source)
		if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
	end
end
