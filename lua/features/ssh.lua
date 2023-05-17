local ret = {}

local function ssh_connect(host, port, user, password)
	if port == '' then
		port = 22
	end

	local cmd = "ssh"
	local terminal = 'term'

	cmd = cmd .. " " .. user .. "@" .. host .. " -p " .. port

	if vim.fn.exists('win32') or vim.fn.isdirectory('/run/WSL') then
		cmd = "tab " .. terminal .. " powershell.exe -C " .. cmd
	else
		if vim.fn.executable('sshpass') == 1 then
			cmd = "sshpass -p " .. password .. " " .. cmd
		else
			vim.api.nvim_echo({{"** Password: " .. password, "MoreMsg"}}, true, {})
		end

		cmd = "tab " .. terminal .. " " .. cmd
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

	return ssh_connect(host_ip, port, usr, pass)
end

ret = {
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
}

vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshConnectReq()")

return ret
