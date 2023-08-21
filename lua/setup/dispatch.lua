local function dispatch_build()
	local compiler = require('features.compiler')
	local status = compiler.Selection()

	if status == false or status == nil
	then
		vim.api.nvim_echo({{"\n" .. "Build not found", "ErrorMsg"}}, true, {})
		return
	end

	if vim.fn.exists(':Make') and vim.fn.exists("$TMUX") then
		vim.cmd("Make")
		return
	end

	vim.cmd("make")
end

local function dispatch_setup_kepmapping()
	vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd> lua require('setup.dispatch').Build() <CR>]], {silent = true})
end

dispatch_setup_kepmapping()

local ret = {
	Build = dispatch_build,
}

return ret
