local lfs = require("lfs")

local function get_dirs_with_pattern(pattern)
	for dir in lfs.dir(".") do
		if dir ~= "." and dir ~= ".." then
			local dir_path = "./" .. dir
			local mode = lfs.attributes(dir_path, "mode")
			if mode == "directory" and dir:match(pattern) then
				return dir_path
			end
		end
	end
	return nil
end

local function get_file_dir()
	local current_file_dir = vim.fn.expand('%:p:h')
	return current_file_dir
end

local function get_file_name()
	local current_file_name = vim.fn.expand('%:t')
	return current_file_name
end

local function do_chg_wd()
	local current_file_dir = get_file_dir()
	print('Changing working directory to: ' .. current_file_dir)
	vim.loop.chdir(current_file_dir)
end

local function setup_lazygit()
	if vim.fn.executable('lazygit') == 0 then
		return
	end

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ L = "lazygit", }, { mode = 'n', prefix = "<leader>g" })
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>gL', [[<cmd> TermExec cmd="lazygit; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>gL', [[<cmd> tab term lazygit; exit <CR>]], { silent = true })
end

local function setup_htop()
	if vim.fn.executable('htop') == 0 then
		return
	end

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ H = "htop", }, { mode = 'n', prefix = "<leader>g" })
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>gH', [[<cmd> TermExec cmd="htop; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>gH', [[<cmd> tab term htop; exit <CR>]], { silent = true })
end

local function setup_ncdu()
	if vim.fn.executable('ncdu') == 0 then
		return
	end

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ N = "ncdu", }, { mode = 'n', prefix = "<leader>g" })
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>gN', [[<cmd> TermExec cmd="ncdu; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>gN', [[<cmd> tab term ncdu; exit <CR>]], { silent = true })
end

setup_lazygit()
setup_htop()
setup_ncdu()

local ret = {
	DoChgWd = do_chg_wd,
	GetFileDir = get_file_dir,
	GetFileName = get_file_name,
	GetDirWithPattern = get_dirs_with_pattern,
}

for name in pairs(ret) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('features.system')." .. name .. "()" .. ")")
end

vim.cmd("command! -nargs=1 GetDirWithPattern lua print(require('features.system').GetDirWithPattern(<f-args>))")

return ret
