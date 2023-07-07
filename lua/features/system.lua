local function get_file_dir()
	local current_file_dir = vim.fn.expand('%:p:h')
	vim.fn.setreg('+', tostring(current_file_dir))
	return current_file_dir
end

local function get_file_name()
	local current_file_name = vim.fn.expand('%:t')
	vim.fn.setreg('+', tostring(current_file_name))
	return current_file_name
end

local function get_full_path()
	local path = vim.fn.expand('%:p')
	vim.fn.setreg('+', tostring(path))
	return path
end

local function get_path()
	local path = vim.fn.expand('%')
	vim.fn.setreg('+', tostring(path))
	return path
end

local function check_extension_file_exist(extension)
	local cmd = "find . -type f -name " .. '"*."' .. extension .. " -print -quit | wc -l"
	local result = tonumber(vim.fn.system(cmd))

	return result
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

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsL', [[<cmd> TermExec cmd="lazygit; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsL', [[<cmd> tabnew | term lazygit; exit <CR>]], { silent = true })
end

local function setup_htop()
	if vim.fn.executable('htop') == 0 then
		return
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsH', [[<cmd> TermExec cmd="htop; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsH', [[<cmd> tab term htop; exit <CR>]], { silent = true })
end

local function setup_ncdu()
	if vim.fn.executable('ncdu') == 0 then
		return
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsN', [[<cmd> TermExec cmd="ncdu; exit" <CR>]], { silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsN', [[<cmd> tab term ncdu; exit <CR>]], { silent = true })
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

local function get_git_info(cmd, arg)
	local function remote_url(git_cmd, remote_name)
		local url = vim.fn.system(git_cmd .. ' config --get remote.' .. remote_name ..'.url')
		return vim.fn.trim(url)
	end

	local function branch(git_cmd)
		local branch = vim.fn.system(git_cmd .. " branch --show-current")

		if branch ~= '' then
			return vim.fn.trim(branch)
		end

		local commita_hash = vim.fn.system(git_cmd .. " rev-parse --short HEAD")

		return vim.fn.trim(commita_hash)
	end

	local current_file_path = vim.fn.expand('%:p:h')

	if current_file_path == '' then
		return ''
	end

	local git_cmd = 'git -C ' .. current_file_path
	local git_rep_exists = vim.fn.system(
		"if " .. git_cmd .. " rev-parse --is-inside-work-tree >/dev/null 2>&1 ; then\
			echo 1;\
		else \
			echo 0;\
		fi")

	if tonumber(git_rep_exists) == 0 then
		return ''
	end

	if cmd == 'branch' then
		return branch(git_cmd)
	end

	if cmd == 'remote' then
		return remote_url(git_cmd, arg)
	end

	return ''
end

local function get_battery_info ()
	if vim.fn.has('unix') == 0 then
		return
	end

	local dir = '/sys/class/power_supply/'
	local bat_pattern = 'BAT%d'
	local bat_dir = {}

	for i = 0, 2 do
		if vim.fn.isdirectory(dir .. string.format(bat_pattern, i)) == 1 then
			table.insert(bat_dir, dir .. string.format(bat_pattern, i))
		end
	end

	if #bat_dir == 0 then
		return
	end

	for _, v in ipairs(bat_dir) do
		local bat_present = tonumber(vim.fn.trim(vim.fn.system('cat ' .. v .. '/present')))
		local bat_status = vim.fn.trim(vim.fn.system('cat ' .. v .. '/status'))
		local bat_capacity = tonumber(vim.fn.trim(vim.fn.system('cat ' .. v .. '/capacity')))
		local current_window = vim.api.nvim_get_current_win()
		local window_width = vim.api.nvim_win_get_width(current_window)

		local bat_cap_hi_color = 'MoreMsg'
		local bat_top_display =				' =========\n'
		local bat_charging_display =		'|██▓▓▓▓▓██|'

		if bat_present == 1 then
			if bat_status == 'Full' then
				bat_cap_hi_color = 'WarningMsg'
				bat_charging_display =		'|█████████|'
			elseif bat_status == 'Charging' or bat_status == 'Unknown' then
				bat_cap_hi_color = 'ModeMsg'
				bat_charging_display =		'|█▓▒░█░▒▓█|'
			elseif bat_capacity <= 25  then
				bat_cap_hi_color = 'errormsg'
				bat_charging_display =		'|█▓▒░░░▒▓█|'
			elseif bat_capacity <= 50  then
				bat_cap_hi_color = 'MsgArea'
				bat_charging_display =		'|█▓▒▒░▒▒▓█|'
			end
		else
			 bat_charging_display =			'|         |'
			 bat_capacity = 0
		end

		local bat_delimiter_display =		'|- - - - -|\n'
		local bat_empty_display =			'|         |'
		local bat_bottom_display =			' =========\n'

		bat_top_display = string.rep(' ', window_width/2.5) .. bat_top_display
		bat_charging_display = string.rep(' ', window_width/2.5) .. bat_charging_display
		bat_delimiter_display = string.rep(' ', window_width/2.5) .. bat_delimiter_display
		bat_empty_display = string.rep(' ', window_width/2.5) .. bat_empty_display
		bat_bottom_display = string.rep(' ', window_width/2.5) .. bat_bottom_display

		print(bat_top_display)
		for percent = 100, 0, -10 do
			if bat_capacity >= percent - 1 then
				vim.api.nvim_echo({{bat_charging_display, bat_cap_hi_color}}, false, {})
			else
				print(bat_empty_display)
			end

			print(bat_delimiter_display)
		end
		print(bat_bottom_display)
	end
end

local function setup_keymapping()
	vim.api.nvim_set_keymap('n', '<leader>vsb', [[<cmd> lua require('features.system').GetBatInfo() <CR>]], { silent = true })
end

setup_lazygit()
setup_htop()
setup_ncdu()
setup_keymapping()

local ret = {
	GetBatInfo = get_battery_info,
	DoChgWd = do_chg_wd,
	GetFileDir = get_file_dir,
	GetFileName = get_file_name,
	GetPath = get_path,
	GetFullPath = get_full_path,
	GetInstallPackageCmd = get_install_package_cmd,
	GetOsLikeId = get_os_like_id,
	ChkExtExist = check_extension_file_exist,
	PwrshCmd = pwrsh_cmd,
	GetGitInfo = get_git_info,
}

for name in pairs(ret) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('features.system')." .. name .. "()" .. ")")
end

vim.cmd("command! -nargs=1 PwrshCmd lua require('features.system').PwrshCmd(<f-args>)")

return ret
