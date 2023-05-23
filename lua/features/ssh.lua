vim.g.ssh_data = {
	{ host = "raspberrypi.local",
		name = "jun",
		pass = "jun",
		port = "22",
		description = "Raspberry Pi 4B",
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

local function ssh_list(save_file)
	local show_pass = false

	if save_file == true then
		local file = '/tmp/ssh_list.txt'

		if vim.fn.tolower(vim.fn.trim(
			vim.fn.input("view password? (y/n): "))) == 'y' then
			show_pass = true
		end

		vim.fn.setreg('"', file)
		vim.cmd([[redir! > ]] .. vim.fn.getreg('"'))
	end

	 local display_msg = string.format("%3s| %-20s | %-10s | %-5s | %-s", "idx",  "hostname/ip", "usrname", "port", "description")
	 print("-----------------------------------------------+")
	 print(display_msg)
	 print("-----------------------------------------------+")

	 for idx, info in ipairs(vim.g.ssh_data) do
		 display_msg = string.format("%3d| %-20s | %-10s | %-5s\t%5s\t", idx, info.host, info.name, info.port, info.description)

		 if save_file == true and show_pass == true then
			 display_msg = display_msg .. "[" .. info.pass .. "]"
		 end

		 vim.api.nvim_echo({{display_msg, "MoreMsg"}}, true, {})
	 end

	print("---------------end of list----------------------+")

	if save_file == true then
		vim.cmd([[redir END]])
		vim.cmd([[tabnew ]] .. vim.fn.getreg('"'))
	end
end

local function ssh_run()
	ssh_list(false)

	local sel_idx = tonumber(vim.fn.input("Enter number to run ssh: "))
	local sel_ssh = vim.g.ssh_data[sel_idx]

	if sel_ssh == nil then
		vim.api.nvim_echo({{"\nInvalid index", "WarningMsg"}}, true, {})
		return
	end

	vim.api.nvim_echo({{"\nStart SSH connecting ...", "none"}}, true, {})
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
	SshList = ssh_list,
}

vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")
vim.cmd("command! -nargs=0 SshList lua require('features.ssh').SshList(true)")

return ret
