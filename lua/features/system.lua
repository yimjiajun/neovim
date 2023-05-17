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

local function pwrsh_cmd(cmd)
	if vim.fn.executable('powershell.exe') == 0 then
		vim.api.nvim_echo({{"powershell not supporting ...", "WarningMsg"}}, true, {})
		return nil
	end

	cmd = "powershell.exe" .. ' -C ' .. cmd
	print(vim.fn.system(cmd))

	return cmd
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

local function get_os_like_id()
	local id = ''
	if vim.fn.has('mac') == 1 then
		id = vim.fn.system("echo $OSTYPE")
	elseif vim.fn.has('unix') == 1 then
		id = vim.fn.system("cat /etc/os-release | grep ID_LIKE | cut -d '=' -f 2")
	else
		id = 'unknown'
	end

	return vim.fn.trim(id)
end

local function get_install_package_cmd()
	local install_cmd = nil

	if vim.fn.has('mac') == 1 then
		if vim.fn.executable('brew') == 1 then
			install_cmd = 'brew install '
		elseif vim.fn.executable('port') == 1 then
			install_cmd = 'sudo port install'
		end
	elseif vim.fn.has('unix') == 1 then
		if get_os_like_id() == 'debian' then
			install_cmd = 'sudo apt install -y '
		end
	end

	if install_cmd == nil then
		vim.api.nvim_echo({{ 'System install command not found! ...', 'WarningMsg' }}, true, {})
		local usr_install_cmd = vim.fn.input("Please enter system install command: ")
		vim.api.nvim_echo({{ '\nSystem Install Command Provided: ' .. usr_install_cmd, 'Question' }}, true, {})

		local confirm = vim.fn.input("Confirm? (Y/n) ")
		if confirm:match('^%s*[yY].*$') then
			install_cmd = usr_install_cmd
		end
	end

	return install_cmd
end

setup_lazygit()
setup_htop()
setup_ncdu()

local ret = {
	DoChgWd = do_chg_wd,
	GetFileDir = get_file_dir,
	GetFileName = get_file_name,
	GetDirWithPattern = get_dirs_with_pattern,
	GetInstallPackageCmd = get_install_package_cmd,
	GetOsLikeId = get_os_like_id,
	PwrshCmd = pwrsh_cmd,
}

for name in pairs(ret) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('features.system')." .. name .. "()" .. ")")
end

vim.cmd("command! -nargs=1 GetDirWithPattern lua print(require('features.system').GetDirWithPattern(<f-args>))")
vim.cmd("command! -nargs=1 PwrshCmd lua require('features.system').PwrshCmd(<f-args>)")

return ret
