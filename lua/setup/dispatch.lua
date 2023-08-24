local function dispatch_build(mode)
	local compiler = require('features.compiler')
	local status

	if mode == "latest"
	then
		status = compiler.LatestSetup()
	else
		status = compiler.Setup()
	end

	if status == nil
	then
		local msg = "\nBuild not found\n"
		vim.api.nvim_echo({{msg, "ErrorMsg"}}, true, {})
		return
	end

	if status == false
	then
		return
	end

	vim.cmd("Make")
end

local function dispatch_setup_kepmapping()
	vim.api.nvim_set_keymap('n', '<leader>b',
		[[<cmd> lua require('setup.dispatch').Build() <CR>]],
		{silent = true})
	vim.api.nvim_set_keymap('n', '<leader>B',
		[[<cmd> lua require('setup.dispatch').Build("latest") <CR>]],
		{silent = true})
end

dispatch_setup_kepmapping()

local ret = {
	Build = dispatch_build,
}

return ret
