local function pwrsh_cmd(cmd)
	if vim.fn.executable('powershell.exe') == 0 then
		vim.api.nvim_echo({{"powershell not supporting ...", "WarningMsg"}}, true, {})
		return nil
	end

	cmd = "powershell.exe" .. ' -C ' .. cmd
	print(vim.fn.system(cmd))

	return cmd
end

local function setup_ui_git()
	local git_cmd

	if vim.fn.executable('lazygit') == 1 then
		git_cmd = 'lazygit'
	end

	if vim.fn.executable('gitui') == 1 then
		git_cmd = 'gitui'
	end

	if git_cmd == nil then
		if vim.fn.exists(':Git') then
			vim.api.nvim_set_keymap('n', '<leader>vsG',
				[[<cmd> Git <CR>]], { silent = true })
		end

		return
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsG',
			[[<cmd> TermExec cmd="]] .. git_cmd .. [[; exit" <CR>]],
			{ silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsG',
		[[<cmd> ]] .. git_cmd .. [[; exit <CR>]],
		{ silent = true })
end

local function setup_top()
	local top_cmd = 'top'

	if vim.fn.executable('htop') == 1 then
		top_cmd = 'htop'
	end

	if vim.fn.executable('bpytop') == 1 then
		top_cmd = 'bpytop'
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsT',
			[[<cmd> TermExec cmd="]] .. top_cmd .. [[; exit" <CR>]],
			{ silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsT',
	[[<cmd> term ]] .. top_cmd .. [[; exit <CR>]], { silent = true })
end

local function setup_disk_usage()
	local du_cmd='clear;' .. 'du -h --max-depth=1 %:h' .. '; read -n 1'

	if vim.fn.executable('ncdu') == 1 then
		du_cmd='ncdu %:h'
	end

	if vim.fn.executable('dutree') == 1 then
		du_cmd='clear;' .. 'dutree -d1 %:h' .. '; read -n 1'
	end

	if vim.fn.exists(':ToggleTerm') then
		vim.api.nvim_set_keymap('n', '<leader>vsD',
			[[<cmd> TermExec cmd="]] .. du_cmd .. [[; exit" <CR>]],
			{ silent = true })
		return
	end

	vim.api.nvim_set_keymap('n', '<leader>vsD',
		[[<cmd> term ]] .. du_cmd .. [[; exit <CR>]],
		{ silent = true })
end

local function get_os_like_id()
	local id

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
				bat_cap_hi_color = 'MoreMsg'
				bat_charging_display =		'|█▓▒░█░▒▓█|'
			elseif bat_capacity <= 25  then
				bat_cap_hi_color = 'Error'
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
		for percent = 100, 1, -10 do
			if bat_capacity >= percent then
				vim.api.nvim_echo({{bat_charging_display, bat_cap_hi_color}}, false, {})
			else
				print(bat_empty_display)
			end

			print(bat_delimiter_display)
		end
		print(bat_bottom_display)
	end
end

local function calendar_interactive()
	local terminal = 'term'

	if (vim.fn.exists(":ToggleTerm") ~= 0) and (vim.fn.exists(":TermCmd") ~= 0) then
		terminal = 'TermCmd'
	end

	if vim.fn.executable('khal') == 1 then
		vim.cmd(terminal .. ' khal interactive ; exit')
		return
	end

	if vim.fn.executable('cal') == 1 then
		vim.cmd(terminal .. ' cal -y; exit')
		return
	end

	vim.cmd('!date')
end

local function setup_keymapping()
	local function setup_calander()
		if vim.fn.executable('khal') == 0 then
			return
		end

		vim.api.nvim_set_keymap('n', '<leader>vct',
			[[<cmd> sp | term khal list today <CR>]],
			{ silent = true, desc = 'khal list today'})

		vim.api.nvim_set_keymap('n', '<leader>vci',
			[[<cmd> lua require('features.system').GetCalendar() <CR>]],
		{ silent = true, desc = 'show calendar' })

		vim.api.nvim_set_keymap('n', '<leader>vcc',
			[[<cmd> sp | term khal calendar --format '● {start-time} | {title}' <CR>]],
			{ silent = true, desc = 'khal calendar agenda'})
	end

	vim.api.nvim_set_keymap('n', '<leader>vsb',
		[[<cmd> lua require('features.system').GetBatInfo() <CR>]],
		{ silent = true, desc = 'show battery info'})
	setup_calander()
end

local function json_file_write(tbl, path)
	if tbl == nil then
		vim.api.nvim_echo({{"empty table ...",
			"ErrorMsg"}}, false, {})
		return false
	end

	if path == nil or #path == 0 then
		vim.api.nvim_echo({{"file path is empty ...",
			"ErrorMsg"}}, false, {})
		return false
	end

	local json_format = vim.json.encode(tbl)
	local file = io.open(path, "w")

	if file == nil then
		vim.api.nvim_echo({{"file open failed ...",
			"ErrorMsg"}}, false, {})
		return false
	end

	file:write(json_format)
	file:close()

	return true
end

local function json_file_read(path)
	if path == nil then
		vim.api.nvim_echo({{"file path is empty ...",
			"ErrorMsg"}}, false, {})
		return false
	end

	local file = io.open(path, "r")

	if file == nil then
		vim.api.nvim_echo({{"file open failed ...",
			"ErrorMsg"}}, false, {})
		return nil
	end

	local json_format = file:read("*a")
	file:close()

	if #json_format == 0 then
		return {}
	end

	return vim.json.decode(json_format)
end

local function run_system_command(cmd)
	local handle, result

	handle = io.popen(tostring(cmd))

	if handle == nil then
		vim.api.nvim_echo({{"run system command failed ...",
			"ErrorMsg"}}, false, {})
		return ''
	end

	result = handle:read("*a")
	handle:close()

	return result
end

local function setup()
	setup_ui_git()
	setup_top()
	setup_disk_usage()
	setup_keymapping()

	for name in pairs(require('features.system')) do
		local callback = "require('features.system')." .. name .. "()"
		vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. callback .. ")" )
	end

	vim.cmd("command! -nargs=1 PwrshCmd lua require('features.system').PwrshCmd(<f-args>)")
end

return {
	Setup = setup,
	GetBatInfo = get_battery_info,
	GetInstallPackageCmd = get_install_package_cmd,
	GetOsLikeId = get_os_like_id,
	PwrshCmd = pwrsh_cmd,
	GetCalendar = calendar_interactive,
	GetJsonFile = json_file_read,
	SetJsonFile = json_file_write,
	RunSysCmd = run_system_command
}
