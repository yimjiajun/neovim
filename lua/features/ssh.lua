vim.g.ssh_data = {
	{ host = "raspberrypi",
		name = "jun",
		pass = "jun",
		port = "22",
		description = "Raspberry Pi 4B",
	},
}

local ret = {}

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

local function ssh_run()
		 local display_msg = string.format("%3s| %-20s | %-10s | %-5s | %-s", "idx",  "hostname/ip", "usrname", "port", "description")
		 print("-----------------------------------------------+")
		 print(display_msg)
		 print("-----------------------------------------------+")
	for idx, info in ipairs(vim.g.ssh_data) do
		 display_msg = string.format("%3d| %-20s | %-10s | %-5s\t%5s", idx, info.host, info.name, info.port, info.description)
		 vim.api.nvim_echo({{display_msg, "MoreMsg"}}, true, {})
	end

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

ret = {
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
	SshRun = ssh_run,
	SshInsertInfo = ssh_insert_info,
}

vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")

return ret
