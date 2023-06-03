vim.g.ssh_data = {
	{ host = "raspberrypi.local",
		name = "jun",
		pass = "jun",
		port = "22",
		description = "Raspberry Pi 4B",
		group = "raspberry",
	},
}

local function ssh_connect(user, host, port, password)
	if port == '' then
		port = 22
	end

	local cmd = "ssh"
	local terminal = 'term'

	cmd = cmd .. " " .. user .. "@" .. host .. " -p " .. port

	if vim.fn.exists('win32') or vim.fn.isdirectory('/run/WSL') then
		cmd = "tabnew | " .. terminal .. " " .. "echo 'password: " .. password .. "';" .. " powershell.exe -C " .. cmd
	else
		if vim.fn.executable('sshpass') == 1 then
			cmd = "sshpass -p " .. password .. " " .. cmd
		else
			cmd = "echo 'password: " .. password .. "';" .. cmd
		end

		cmd = "tabnew | " .. terminal .. " " .. cmd
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

local function display_delimited_line(delimited_character)
	local current_window = vim.api.nvim_get_current_win()
	local window_width = vim.api.nvim_win_get_width(current_window)
	local delimited_mark = tostring(delimited_character or "=")
	local delimited_len = window_width - 10
	local display_msg = ""

	for i = 1, delimited_len do
		display_msg = display_msg .. delimited_mark
	end

	print(display_msg)
end

local function display_tittle(tittle)
	local display_msg = string.format("%4s", tittle)

	display_delimited_line()
	print(display_msg)
	display_delimited_line()
end

local function ssh_list_get_group()
	local group_list = {}

	for _, info in ipairs(vim.g.ssh_data) do
		local cnt = 1
		repeat
			if group_list[cnt] ~= info.group then
				table.insert(group_list, info.group)
				break
			else
				cnt = cnt + 1
			end
		until cnt < #group_list
	end

	display_tittle("SSH Group List")

	for idx, grp in ipairs(group_list) do
		print(string.format("%3d| %s", idx, grp))
	end

	local sel_idx = tonumber(vim.fn.input("Enter number to select ssh group: "))
	local sel_grp = group_list[sel_idx]

	if sel_grp == nil then
		vim.api.nvim_echo({{"\nInvalid selection", "WarningMsg"}}, false, {})
		return
	end

	return sel_grp
end

local function ssh_get_list(save_file)
	local show_pass = false
	local ssh_sel_list = {}
	local group = ssh_list_get_group()

	if group == nil then
		return nil
	end

	if save_file == true then
		local file = '/tmp/ssh_list.txt'

		if vim.fn.tolower(vim.fn.trim(
			vim.fn.input("view password? (y/n): "))) == 'y' then
			show_pass = true
		end

		vim.fn.setreg('"', file)
		vim.cmd([[redir! > ]] .. vim.fn.getreg('"'))
	end

	 local display_msg = string.format("%3s| %-20s | %-20s | %-5s | %-s", "idx",  "hostname/ip", "usrname", "port", "description")
	 display_tittle(display_msg)

	 local idx = 1
	 for _, info in ipairs(vim.g.ssh_data) do
		 if info.group ~= group then
			 goto continue
		 end

		 display_msg = string.format("%3d| %-20s | %-20s | %-5s | %-s", idx, info.host, info.name, info.port, info.description)
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
		vim.cmd([[tabnew ]] .. vim.fn.getreg('"') .. " | setlocal readonly")
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

local function ssh_insert_info(username, hostname, port, password, description)
	local data = vim.g.ssh_data
	local info = {
		name = username,
		host = hostname,
		port = port,
		pass = password,
		description = description,
	}

	table.insert(data, info)
	vim.g.ssh_data = data
end

local function setting_key_ssh()
	vim.api.nvim_set_keymap('n', '<leader>tS', [[<cmd> lua require('features.ssh').SshRun() <CR> ]], { silent = true })
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

setting_key_ssh()

local ret = {
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
	SshRun = ssh_run,
	SshInsertInfo = ssh_insert_info,
	SshList = ssh_get_list,
}

vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")
vim.cmd("command! -nargs=0 SshList lua require('features.ssh').SshList(true)")

return ret
