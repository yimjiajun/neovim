vim.g.wsl_ssh_run_win = 0
vim.g.ssh_run_sshpass = 1
vim.g.ssh_data = {}

local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local ssh_data_dir = vim.fn.stdpath('data') .. delim .. 'ssh'
local display_title = require("features.common").DisplayTitle
local ssh_list_get_group = require("features.common").GroupSelection

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
		local file = vim.fn.tempname() .. ".txt"

		if vim.fn.tolower(vim.fn.trim(
			vim.fn.input("view password? (y/n): ", 'y'))) == 'y'
		then
			show_pass = true
		end

		vim.api.nvim_echo({{"\nredirecting ssh information to file", "none"}}, false, {})
		vim.fn.setreg('"', file)
		vim.cmd([[redir! > ]] .. vim.fn.getreg('"'))
	end

	local idx = 1
	local msg = {}

	for _, info in ipairs(vim.g.ssh_data) do
		if info.group ~= group
		then
			goto continue
		end

		msg[idx] = string.format("%3d | %-20s | %-20s | %-5s | %-s",
			idx, info.host, info.name, info.port, info.description)

		if save_file == true and show_pass == true
		then
			msg[idx] = msg[idx] ..
			"\t" .. "[" .. info.pass .. "]"
		end

		table.insert(ssh_sel_list, info)
		idx = idx + 1
		::continue::
	end

	if #ssh_sel_list == 0 then
		return nil
	end

	display_title(string.format(
		"%3s | %-20s | %-20s | %-5s | %-s",
		"idx",  "hostname/ip", "username", "port", "description"
		)
	)

	local sel = vim.fn.inputlist(msg)

	if save_file == true then
		vim.cmd([[redir END]])
		vim.cmd([[edit ]] .. vim.fn.getreg('"') .. " | setlocal readonly")

		return nil
	end

	if sel == 0 or sel > #ssh_sel_list
	then
		return nil
	end

	return ssh_sel_list[sel]
end

local function ssh_run()
	local sel_ssh = ssh_get_list(false)

	if sel_ssh == nil then
		vim.api.nvim_echo({{"\nSsh not found", "ErrorMsg"}}, true, {})
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
	if vim.fn.has('unix') == 1 and vim.fn.isdirectory('/run/WSL') == 0 then
		return
	end

	vim.g.wsl_ssh_run_win = (vim.g.wsl_ssh_run_win == 1 and 0 or 1)
	local msg = (vim.g.wsl_ssh_run_win == 1) and "powershell" or "wsl"
	vim.api.nvim_echo({{"[ SSH ]" .. " -> " .. msg,
		"WarningMsg"}}, false, {})
end

local function toggle_sshpass()
	if vim.fn.executable('sshpass') == 0 or vim.g.wsl_ssh_run_win == 1 then
		return
	end

	vim.g.ssh_run_sshpass = (vim.g.ssh_run_sshpass == 1 and 0 or 1)
	local msg = (vim.g.ssh_run_sshpass == 1) and "on" or "off"
	vim.api.nvim_echo({{"[ SSHpass ]" .. " credential -> " .. msg,
		"WarningMsg"}}, false, {})
end

local function ssh_setting_keymapping()
	local wk = nil

	vim.api.nvim_set_keymap('n', '<leader>tS',
		[[<cmd> lua require('features.ssh').SshRun() <CR> ]],
		{ silent = true })

	if vim.fn.has('unix') == 0 then
		return
	end

	if pcall(require, "which-key") then
		 wk = require("which-key")
	end

	if vim.fn.isdirectory('/run/WSL') == 1 then
		vim.api.nvim_set_keymap('n', '<leader>mS',
			[[<cmd> lua require('features.ssh').SshTogglePwrsh() <CR> ]],
			{ silent = true })

		if wk ~= nil then
			wk.register({
				S = "toggle ssh on wsl/win",
				}, { mode = "n", prefix = "<leader>m" })
		end
	end

	if vim.fn.executable('sshpass') == 1 then
		vim.api.nvim_set_keymap('n', '<leader>ms',
			[[<cmd> lua require('features.ssh').SshToggleSshpass() <CR> ]],
			{ silent = true })

		if wk ~= nil then
			wk.register({
				s = "toggle sshpass",
				}, { mode = "n", prefix = "<leader>m" })
		end
	end
end

local function ssh_setting()
	local wk =nil

	vim.api.nvim_set_keymap('n', '<leader>vS',
		[[<cmd> lua require('features.ssh').SshList(true) <CR> ]], { silent = true })

	if pcall(require, "which-key") then
		wk = require("which-key")
	end

	if wk ~= nil then
		wk.register({ S = "SSH connect" }, { mode = "n", prefix = "<leader>t" })
		wk.register({ S = "SSH list", }, { mode = "n", prefix = "<leader>v" })
	end
end

local function ssh_read_json()
	if vim.fn.isdirectory(ssh_data_dir) == 0 then
		return
	end

	local ssh_data_files = require('features.system').SearchFile(ssh_data_dir, ".json")
	local ssh_data = {}

	for _, f in ipairs(ssh_data_files) do
		local info = require('features.system').GetJsonFile(f)

		if info == nil then
			goto continue
		end

		table.insert(ssh_data, info)
		::continue::
	end

	for _, grp in pairs(ssh_data) do
		for grp_name, grp_info in pairs(grp) do
			for _, i in pairs(grp_info) do
				ssh_insert_info(i.username, i.hostname, i.port, i.pass, i.description, grp_name)
			end
		end
	end
end

local function setup()
	vim.g.ssh_data = {
		{ host = "raspberrypi.local",
			name = "jun",
			pass = "jun",
			port = "22",
			description = "Raspberry Pi 4B",
			group = "computer",
		}
	}
	ssh_setting()
	ssh_setting_keymapping()
	ssh_read_json()

	vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
	vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")
	vim.cmd("command! -nargs=0 SshList lua require('features.ssh').SshList(true)")
end

return {
	Setup = setup,
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
	SshRun = ssh_run,
	SshInsertInfo = ssh_insert_info,
	SshList = ssh_get_list,
	SshTogglePwrsh = toggle_powershell_ssh,
	SshToggleSshpass = toggle_sshpass,
}
