vim.g.wsl_ssh_run_win = 0
vim.g.ssh_run_sshpass = 1
vim.g.ssh_data = {
	{ host = "raspberrypi.local",
		name = "jun",
		pass = "jun",
		port = "22",
		description = "Raspberry Pi 4B",
		group = "computer",
	},
}

local common = require("features.common")
local display_tittle = common.DisplayTittle
local display_delimited_line = common.DisplayDelimitedLine
local ssh_list_get_group = common.GroupSelection

local function ssh_connect(user, host, port, password)
	if port == '' then
		port = 22
	end

	local cmd = "ssh"
	local terminal = 'term'

	cmd = cmd .. " " .. user .. "@" .. host .. " -p " .. port

	vim.fn.setreg('+', tostring(password))

	if vim.fn.exists('win32') == 1 or (vim.fn.isdirectory('/run/WSL') == 1 and vim.g.wsl_ssh_run_win == 1) then
		cmd = terminal .. " " .. " powershell.exe -C " .. cmd
	else
		if vim.fn.executable('sshpass') == 1 and
			vim.g.ssh_run_sshpass == 1 and
			password ~= "" and password ~= nil then

			cmd = "sshpass -p '" .. password .. "' " .. cmd
		end

		cmd = terminal .. " " .. cmd
	end

	vim.cmd(cmd)

	return cmd
end

local function ssh_connect_request()
	local host_ip = vim.fn.input("Host/ip: ")
	local usr = vim.fn.input("Username: ")
	local port = vim.fn.input("Port: ")
	local pass = vim.fn.inputsecret("Password: ")

	if host_ip == "" or usr == "" or pass == "" then
		vim.api.nvim_echo({{"** Invalid input", "ErrorMsg"}}, true, {})
		return
	end

	return ssh_connect(usr, host_ip, port, pass)
end

local function ssh_get_list(save_file)
	local show_pass = false
	local ssh_sel_list = {}
	local group = ssh_list_get_group(vim.g.ssh_data)

	if group == nil then
		return nil
	end

	if save_file == true then
		local file = '/tmp/ssh_list.txt'

		if vim.fn.tolower(vim.fn.trim(
			vim.fn.input("view password? (y/n): ", 'y'))) == 'y' then
			show_pass = true
		end

		vim.api.nvim_echo({{"\nredirecting ssh information to file", "none"}}, false, {})
		vim.fn.setreg('"', file)
		vim.cmd([[redir! > ]] .. vim.fn.getreg('"'))
	end

	local display_msg = string.format("%3s| %-20s | %-20s | %-5s | %-s",
		"idx",  "hostname/ip", "username", "port", "description")

	display_tittle(display_msg)

	local idx = 1

	for _, info in ipairs(vim.g.ssh_data) do
		if info.group ~= group then
			goto continue
		end

		display_msg = string.format("%3d| %-20s | %-20s | %-5s | %-s",
			idx, info.host, info.name, info.port, info.description)

		if save_file == true and show_pass == true then
			display_msg = display_msg .. "\t" .. "[" .. info.pass .. "]"
		end

		vim.api.nvim_echo({{display_msg, "none"}}, true, {})

		if idx % 2 == 0 then
			if idx % 4 == 0 then
				display_delimited_line("~")
			else
				display_delimited_line("-")
			end
		end

		table.insert(ssh_sel_list, info)
		idx = idx + 1
		::continue::
	end

	if save_file == true then
		vim.cmd([[redir END]])
		vim.cmd([[edit ]] .. vim.fn.getreg('"') .. " | setlocal readonly")
	end

	return ssh_sel_list
end

local function ssh_run()
	local ssh_list = ssh_get_list(false)

	if ssh_list == nil then
		return
	end

	local sel_idx = tonumber(vim.fn.input("Enter number to run ssh: "))
	local sel_ssh = ssh_list[sel_idx]

	if sel_ssh == nil then
		vim.api.nvim_echo({{"\nInvalid index", "WarningMsg"}}, false, {})
		return
	end

	ssh_connect(sel_ssh.name, sel_ssh.host, sel_ssh.port, sel_ssh.pass)
end

local function ssh_insert_info(username, hostname, port, password, description, group)
	local data = vim.g.ssh_data
	local info = {
		name = username,
		host = hostname,
		port = port,
		pass = password,
		description = description,
		group = group,
	}

	table.insert(data, info)
	vim.g.ssh_data = data
end

local function toggle_powershell_ssh()

	if vim.fn.has('unix') == 1 and vim.fn.isdirectory('/run/WSL') == 1 then
		local msg = "wsl"
		vim.g.wsl_ssh_run_win = (vim.g.wsl_ssh_run_win == 1 and 0 or 1)

		if vim.g.wsl_ssh_run_win == 1 then
			msg = "windows"
		end

		vim.api.nvim_echo({{"ssh from " .. msg,
			"WarningMsg"}}, true, {})
	end

end

local function toggle_sshpass()
	if vim.fn.executable('sshpass') == 0 or vim.g.wsl_ssh_run_win == 1 then
		return
	end

	local msg = "normal"
	vim.g.ssh_run_sshpass = (vim.g.ssh_run_sshpass == 1 and 0 or 1)

	if vim.g.ssh_run_sshpass == 1 then
		msg = "auto"
	end

	vim.api.nvim_echo({{"ssh credential: " .. msg,
		"WarningMsg"}}, true, {})
end

local function ssh_setting_keymapping()
	vim.api.nvim_set_keymap('n', '<leader>tS',
		[[<cmd> lua require('features.ssh').SshRun() <CR> ]],
		{ silent = true })

	if vim.fn.has('unix') == 1 then
		if vim.fn.isdirectory('/run/WSL') == 1 then
			vim.api.nvim_set_keymap('n', '<leader>mS',
				[[<cmd> lua require('features.ssh').SshTogglePwrsh() <CR> ]],
				{ silent = true })

			if pcall(require, "which-key") then
				local wk = require("which-key")
				wk.register({
					S = "toggle ssh on wsl/win",
				}, { mode = "n", prefix = "<leader>m" })
			end
		end

		if vim.fn.executable('sshpass') == 1 then
			vim.api.nvim_set_keymap('n', '<leader>ms',
				[[<cmd> lua require('features.ssh').SshToggleSshpass() <CR> ]],
				{ silent = true })

			if pcall(require, "which-key") then
				local wk = require("which-key")
				wk.register({
					s = "toggle sshpass",
				}, { mode = "n", prefix = "<leader>m" })
			end
		end
	end
end

local function ssh_setting()

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({
			S = "SSH connect",
		}, { mode = "n", prefix = "<leader>t" })
	end

	vim.api.nvim_set_keymap('n', '<leader>vS', [[<cmd> lua require('features.ssh').SshList(true) <CR> ]], { silent = true })
	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({
			S = "SSH list",
		}, { mode = "n", prefix = "<leader>v" })
	end
end

ssh_setting()
ssh_setting_keymapping()

local ret = {
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
	SshRun = ssh_run,
	SshInsertInfo = ssh_insert_info,
	SshList = ssh_get_list,
	SshTogglePwrsh = toggle_powershell_ssh,
	SshToggleSshpass = toggle_sshpass,
}

vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")
vim.cmd("command! -nargs=0 SshList lua require('features.ssh').SshList(true)")


return ret
