local function dispatch_build(mode)
	local compiler = require('features.compiler')
	local status

	if mode == "latest" then
		status = compiler.LastSelect()
	else
		status = compiler.Selection()
	end

	if status == nil then
		local msg = "\nBuild not found\n"
		vim.api.nvim_echo({{msg, "ErrorMsg"}}, true, {})
		return
	end

	if status == false then
		return
	end

	vim.cmd("Make")
end

local function setup()
	local function setup_keymap()
		local keymap = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		keymap('n', '<leader>b', [[<cmd> lua require('plugin.dispatch').Build() <CR>]], opts)
		keymap('n', '<leader>B', [[<cmd> lua require('plugin.dispatch').Build("latest") <CR>]], opts)
	end

	setup_keymap()
end

return {
	Build = dispatch_build,
	Setup = setup
}
