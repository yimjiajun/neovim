vim.g.wsl_ssh_run_win = 0
vim.g.ssh_run_sshpass = 1
vim.g.ssh_data = {}

local async_cmd = require("features.common").AsyncCommand
local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local ssh_data_dir = vim.fn.stdpath('data') .. delim .. 'ssh'
-- for desktop ssh connection (win32: .rdp, unix: .desktop)
local ssh_desktop_data_dir = ssh_data_dir .. delim .. 'desktop'
local display_title = require("features.common").DisplayTitle
local ssh_list_get_group = require("features.common").GroupSelection

-- @brief: ssh_connect
-- @description: connect to remote server via ssh
-- @usage: lua require('features.ssh').ssh_connect(<username>, <hostname>, <port>, <password>)
-- @param: username: username
-- @param: hostname: hostname/ip
-- @param: port: port number
-- @param: password: password
-- @return: nil
local function ssh_connect(username, hostname, port, password)
	local cmd = "ssh"
	local terminal = 'term'
  port = (port == nil or port == '') and "22" or port
	cmd = cmd .. " " .. username .. "@" .. hostname .. " -p " .. port
  -- set password to clipboard
	vim.fn.setreg('+', tostring(password))

	if vim.fn.exists('win32') == 1 or (vim.fn.isdirectory('/run/WSL') == 1 and vim.g.wsl_ssh_run_win == 1) then
		cmd = terminal .. " " .. " powershell.exe -C " .. cmd
	else
		if vim.fn.executable('sshpass') == 1 and vim.g.ssh_run_sshpass == 1 and password ~= nil and password ~= "" then
			cmd = "sshpass -p '" .. password .. "' " .. cmd
		end

		cmd = terminal .. " " .. cmd
	end

	vim.cmd(cmd)

	return cmd
end

-- @brief: ssh_connect_request
-- @description: request ssh information to connect
-- @usage: lua require('features.ssh').ssh_connect_request()
-- @return: nil
local function ssh_connect_request()
	local host_ip = vim.fn.input("hostname/ip: ")
	local usr = vim.fn.input("Username: ")
	local port = vim.fn.input("Port: ")
	local password = vim.fn.inputsecret("Password: ")

	if host_ip == "" or usr == "" or password == "" then
		vim.api.nvim_echo({{"** Invalid input", "ErrorMsg"}}, true, {})
		return
	end

	return ssh_connect(usr, host_ip, port, password)
end

-- @brief: ssh_get_list
-- @description: get ssh information list
-- @usage: lua require('features.ssh').ssh_get_list(<save_file>)
-- @param: save_file: save ssh information to file to view
-- @usage: lua require('features.ssh').ssh_get_list(true)
-- @return: table of ssh information or nil
local function ssh_get_list(save_file)
	local show_pass = false
	local ssh_sel_list = {}
	local group = ssh_list_get_group(vim.g.ssh_data)

	if group == nil then
		return nil
	end

	if save_file == true then
		local file = vim.fn.tempname() .. ".txt"

		if vim.fn.tolower(vim.fn.trim(vim.fn.input("view password? (y/n): ", 'y'))) == 'y' then
			show_pass = true
		end

		vim.api.nvim_echo({{"\nredirecting ssh information to file", "none"}}, false, {})
		vim.fn.setreg('"', file)
		vim.cmd([[redir! > ]] .. vim.fn.getreg('"'))
	end

	local idx = 1
	local msg = {}
  local msg_max_length = {
    alias = vim.fn.strlen("alias"),
    hostname = vim.fn.strlen("hostname/ip"),
    username = vim.fn.strlen("username"),
    port = vim.fn.strlen("port"),
    description = vim.fn.strlen("description")
  }

  for _, info in ipairs(vim.g.ssh_data) do
    if info.group ~= group then
      goto skip_get_max_length
    end

    msg_max_length = {
      alias = math.max(msg_max_length.alias, vim.fn.strlen(info.alias)),
      hostname = math.max(msg_max_length.hostname, vim.fn.strlen(info.hostname)),
      username = math.max(msg_max_length.username, vim.fn.strlen(info.username)),
      port = math.max(msg_max_length.port, vim.fn.strlen(info.port)),
      description = math.max(msg_max_length.description, vim.fn.strlen(info.description)),
    }
    ::skip_get_max_length::
  end

  local msg_format = string.format("%%3s | %%-%ds | %%-%ds | %%-%ds | %%-%ds | %%-s",
    msg_max_length.alias, msg_max_length.hostname, msg_max_length.username, msg_max_length.port)
  local msg_total_length = msg_max_length.alias + msg_max_length.hostname + msg_max_length.username +
    msg_max_length.port + msg_max_length.description + 20
  local separator = string.rep("=", msg_total_length)

	for _, info in ipairs(vim.g.ssh_data) do
		if info.group ~= group then
			goto continue
		end

		msg[idx] = string.format(msg_format,
			idx, info.alias, info.hostname, info.username, info.port, info.description)

		if save_file == true and show_pass == true then
			msg[idx] = msg[idx] .. "\t" .. "[" .. info.password .. "]"
		end

		table.insert(ssh_sel_list, info)
		idx = idx + 1
		::continue::
	end

	if #ssh_sel_list == 0 then
		return nil
	end

	display_title(separator)
  display_title(string.format(msg_format, "idx", "alias", "hostname/ip", "username", "port", "description"))
  display_title(separator)

	local sel = vim.fn.inputlist(msg)

	if save_file == true then
		vim.cmd([[redir END]])
		vim.cmd([[edit ]] .. vim.fn.getreg('"') .. " | setlocal readonly")

		return nil
	end

	if sel == 0 or sel > #ssh_sel_list then
		return nil
	end

	return ssh_sel_list[sel]
end

-- @brief: get_ssh_info_by_name
-- @description: get ssh information by name
-- @usage: lua require('features.ssh').get_ssh_info_by_name(<name>)
-- @param: name: name to search (alias -> hostname -> username)
-- @return: table of ssh information or nil
local function get_ssh_info_by_name(name)
  if name == nil or name == "" then
    goto search_name_not_found
  end

  for _, info in ipairs(vim.g.ssh_data) do
    for _, n in pairs({info.alias, info.hostname, info.username}) do
      if n == name then
        return info
      end
    end
  end

  ::search_name_not_found::
  return nil
end

-- @brief: ssh_run
-- @description: run ssh connection
-- @usage: lua require('features.ssh').ssh_run()
local function ssh_run()
	local sel_ssh = ssh_get_list(false)

	if sel_ssh == nil then
		return
	end

	ssh_connect(sel_ssh.username, sel_ssh.hostname, sel_ssh.port, sel_ssh.password)
end

-- @brief: ssh_insert_info
-- @description: insert ssh information to global variable g:ssh_data
-- @usage: lua require('features.ssh').ssh_insert_info(<opts>)
-- @param: opts: table of ssh information
-- @field: alias: alias name
-- @field: hostname: remote server hostname
-- @field: username: remote server username
-- @field: password: remote server password
-- @field: port: remote server port
-- @field: description: description of remote server
-- @field: group: group name of remote server
-- @return: nil
local function ssh_insert_info(opts)
	local data = vim.g.ssh_data
	local info = {
    alias = opts.alias,
		username = opts.username,
		hostname = opts.hostname,
		port = opts.port,
		password = opts.password,
		description = opts.description,
		group = opts.group,
	}

	table.insert(data, info)
	vim.g.ssh_data = data
end

-- @brief: toggle_powershell_ssh
-- @description: toggle between powershell and wsl ssh
-- @usage: lua require('features.ssh').toggle_powershell_ssh()
local function toggle_powershell_ssh()
	if vim.fn.has('unix') == 1 and vim.fn.isdirectory('/run/WSL') == 0 then
		return
	end

	vim.g.wsl_ssh_run_win = (vim.g.wsl_ssh_run_win == 1 and 0 or 1)
	local msg = (vim.g.wsl_ssh_run_win == 1) and "powershell" or "wsl"
	vim.api.nvim_echo({{"[ SSH ]" .. " -> " .. msg, "WarningMsg"}}, false, {})
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

-- @brief: ssh_keymap_setting
-- @description: setting keymapping for ssh
-- @usage: lua require('features.ssh').ssh_setting()
local function ssh_keymap_setting()
  local wk = (pcall(require, "which-key") == true) and require("which-key") or nil
  local prefix = "<leader>tS"
  local key = function(key) return prefix .. key end
  local keymap_opts = function(desc) return { noremap = true, silent = true, desc = (desc ~= nil) and desc or "" } end
  local keymap_setup = {
    { key = "s", func = [[<cmd> lua require('features.ssh').SshRun() <CR> ]], desc = "ssh connect",
      support = true},
    { key = "f", func = [[<cmd> lua require('features.ssh').SshCopy() <CR> ]], desc = "secure copy",
      support = (vim.fn.executable('scp') == 1) },
    { key = "v", func = [[<cmd> lua require('features.ssh').SshList(true) <CR> ]], desc = "ssh list",
      support = true },
    { key = "P", func = [[<cmd> lua require('features.ssh').SshTogglePwrsh() <CR> ]], desc = "toggle powershell/WSL",
      support = (vim.fn.isdirectory('/run/WSL') == 1) },
    { key = "p", func = [[<cmd> lua require('features.ssh').SshToggleSshpass() <CR> ]], desc = "toggle sshpass",
      support = (vim.fn.executable('sshpass') == 1) },
    { key = "r", func = [[<cmd> lua require('features.ssh').SshReq() <CR> ]], desc = "ssh connect request",
      support = true },
    { key = "F", func = [[<cmd> lua require('features.ssh').SshSftp() <CR> ]], desc = "secret file transfer",
      support = (vim.fn.executable('sftp') == 1) },
    { key = "d", func = [[<cmd> lua require('features.ssh').SshDesktop() <CR> ]], desc = "remote desktop",
      support = true },
  }

  for _, v in ipairs(keymap_setup) do
    if v.support ~= true then
      goto continue
    end

    vim.api.nvim_set_keymap("n", key(v.key), v.func, keymap_opts(v.desc))

    if wk ~= nil then
      wk.register({ [v.key] = v.desc }, { mode = "n", prefix = prefix })
    end
    ::continue::
  end
end

-- @brief: ssh_read_json
-- @description: read ssh data from json files from path ~/.local/share/nvim/ssh
-- @usage: lua require('features.ssh').ssh_read_json()
local function ssh_read_json()
	if vim.fn.isdirectory(ssh_data_dir) == 0 then
		return
	end

	local ssh_data_files = require('features.files').RecurSearch(ssh_data_dir, "*.json")
	local ssh_data = {}

	for _, f in ipairs(ssh_data_files) do
		local info = require('features.files').GetJson(f)

		if info == nil then
			goto continue
		end

		table.insert(ssh_data, info)
		::continue::
	end

	for _, grp in pairs(ssh_data) do
		for grp_name, grp_info in pairs(grp) do
			for _, i in pairs(grp_info) do
        local tbl = {
          alias = (i.alias ~= nil) and i.alias or "",
          hostname = (i.hostname ~= nil) and i.hostname or "",
          username = (i.username ~= nil) and i.username or "",
          password = (i.password ~= nil) and i.password or "",
          port = (i.port ~= nil) and i.port or "",
          description = (i.description ~= nil) and i.description or "",
          group = grp_name
        }
				ssh_insert_info(tbl)
			end
		end
	end
end

-- @brief: secure_copy
-- @description: send file to remote server
-- @usage: lua require('features.ssh').SshCopy()
-- @param: opts: table of ssh information
-- @param: file: file path to send
-- @param: destination: destination path
-- @return: boolean (true: success, false: failed)
local function secure_copy(opts, file, destination)
  display_title("Secure Copy")
  opts = (opts ~= nil) and opts or ssh_get_list(false)

  if opts == nil then
    return false
  end

  local sel_ssh = nil

  if opts.hostname == nil or opts.username == nil then
    sel_ssh = get_ssh_info_by_name(
      (opts.alias ~= nil) and opts.alias or
      (opts.hostname ~= nil) and opts.hostname or opts.username)
  end

  sel_ssh = (sel_ssh == nil) and opts or ssh_get_list(false)

  if sel_ssh == nil then
    vim.api.nvim_echo({{"SSH information not found ...", "WarningMsg"}}, true, {})
    return false
  end

  if file == nil or file == "" then
    file = vim.fn.expand(vim.fn.input("File to send: "))
  end

  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.api.nvim_echo({{"** Invalid file .. " .. file, "ErrorMsg"}}, true, {})
    return false
  end

  if destination == nil or destination == "" then
    destination = vim.fn.expand(vim.fn.input("Remote destination (optional): "))
  end

  local cmd = "scp " .. file .. " " .. sel_ssh.username .. "@" .. sel_ssh.hostname .. ":" .. destination

  if (sel_ssh.password ~= nil and sel_ssh.password ~= "") and
    (vim.fn.executable('sshpass') == 1 and vim.g.ssh_run_sshpass == 1) then
    cmd = "sshpass -p '" .. sel_ssh.password .. "' " .. cmd
  end

  local separator_number = 1

  for _, v in pairs({file, sel_ssh.hostname, sel_ssh.username, destination}) do
    if vim.fn.len(v) > separator_number then
      separator_number = vim.fn.len(v)
    end
  end

  local separator = string.rep("=", separator_number + vim.fn.len("* Hostname:    "))

  vim.api.nvim_echo({{"\n"}}, false, {})
  vim.api.nvim_echo({{separator, "MsgSeparator"}}, true, {})
  vim.api.nvim_echo({{"  SCP", "MoreMsg"}}, true, {})
  vim.api.nvim_echo({{separator, "MsgSeparator"}}, true, {})
  vim.api.nvim_echo({{"* Hostname:    " .. sel_ssh.hostname, "MsgArea"}}, true, {})
  vim.api.nvim_echo({{"* Username:    " .. sel_ssh.username, "MsgArea"}}, true, {})
  vim.api.nvim_echo({{"* File:        " .. file, "MsgArea"}}, true, {})
  vim.api.nvim_echo({{"* Destination: " .. destination, "MsgArea"}}, true, {})
  vim.api.nvim_echo({{separator, "MsgSeparator"}}, true, {})

  if vim.fn.filereadable(file) == 0 then
    vim.api.nvim_echo({{"** File not found .. " .. file, "ErrorMsg"}}, true, {})
    return false
  end

  local ret = (os.execute(cmd) == 0)
  local status_msg = "Failed"
  local msg_type = "ErrorMsg"

  if ret == true then
    status_msg = "Success"
    msg_type = "ModeMsg"
  end

  vim.api.nvim_echo({{"  SCP [ " .. status_msg .. " ]", msg_type}}, true, {})

  if ret ~= true and string.match(cmd, "^sshpass") == nil then
    vim.api.nvim_echo({{"SCP - opening terminal to Enter password..."}}, false, {})
    cmd = string.gsub(cmd, "sshpass -p '.*' ", "")
    vim.cmd("split | term " .. cmd)
  end

  return ret
end

-- @brief: secret_file_transfer
-- @description: secret file transfer via sftp
-- @param: opts: table of ssh information
-- @usage: lua require('features.ssh').secret_file_transfer({
--  username = "username",
--  hostname = "hostname",
--  password = "password",
--  port = "port"
--  })
-- )
-- @return: boolean (true: success, false: failed)
local function secret_file_transfer(opts)
  display_title("Secrete File Transfer")
  opts = (opts ~= nil) and opts or ssh_get_list(false)

  if opts == nil then
    return false
  end

  local cmd = "sftp " .. " -P " .. opts.port .. " " .. opts.username .. "@" .. opts.hostname
  local password_available = (opts.password ~= nil and opts.password ~= "")
  local sshpass_support = (vim.fn.executable('sshpass') == 1 and vim.g.ssh_run_sshpass == 1)

  if password_available and sshpass_support then
    cmd = "sshpass -p '" .. opts.password .. "' " .. cmd
  end

  vim.cmd("split | term " .. cmd)
  return true
end

-- @brief: connect_ssh_desktop
-- @description: connect to remote desktop via remmina / mstsc
-- the remote desktop files should stored in ~/.local/share/nvim/ssh/desktop
-- @usage: lua require('features.ssh').SshDesktop()
-- @param: opts: table of ssh information
-- @return: boolean (true: success, false: failed)
local function connect_ssh_desktop(opts)
  display_title("Remote Desktop")
  opts = (opts ~= nil) and opts or ssh_get_list(false)

  if opts == nil then
    return false
  end

  if opts.username == nil or opts.hostname == nil then
    opts = get_ssh_info_by_name((opts.alias ~= nil) and opts.alias or
      (opts.hostname ~= nil) and opts.hostname or opts.username)

    if opts == nil then
      vim.api.nvim_echo({{"** Invalid SSH information ..", "ErrorMsg"}}, false, {})
      return false
    end
  end

  local desktop_remote_setup = {
    remmina = { cmd = "remmina", ext = ".remmina", opt = "-c" },
    mstsc = { cmd = "powershell.exe -C mstsc", ext = ".rdp", opt = "" }
  }
  local tool = (vim.fn.exists('win32') == 1 or vim.fn.isdirectory('/run/WSL') == 1)
    and "mstsc" or "remmina"
  local desktop_remote_file = ssh_desktop_data_dir .. delim .. opts.hostname .. desktop_remote_setup[tool].ext

  if tool ~= "mstsc" and vim.fn.executable(desktop_remote_setup[tool].cmd) == 0 then
      vim.api.nvim_echo({{desktop_remote_setup[tool].cmd .. " not found ..", "ErrorMsg"}}, false, {})
      return false
  end

  vim.fn.setreg('+', tostring(opts.password))
  vim.api.nvim_echo({{"\n[USERNAME] " .. opts.username, "MoreMsg"}}, true, {})

  if vim.fn.filereadable(desktop_remote_file) > 0 then
    if vim.fn.isdirectory('/run/WSL') == 0 then
      goto start_desktop_by_file
    end

    if vim.fn.isdirectory('/mnt/c/neovim') == 0 then
      vim.fn.mkdir('/mnt/c/neovim')
    end

    vim.fn.system("cp" .. " " .. desktop_remote_file .. " " .. "/mnt/c/neovim/")
    desktop_remote_file = "C:\\neovim\\" .. vim.fn.fnamemodify(desktop_remote_file, ":t")

    ::start_desktop_by_file::
    async_cmd({ commands = {
      desktop_remote_setup[tool].cmd .. " " .. desktop_remote_setup[tool].opt .. " " .. desktop_remote_file
    }, opts = { timeout = 0 } })
    return true
  end

  local cmd

  if tool == "mstsc" then
    async_cmd({ commands = { desktop_remote_setup[tool].cmd .. " " .. "/v:" .. opts.hostname },
      opts = { timeout = 0 } })
  else
    if vim.fn.executable('sshpass') == 1 and opts.password ~= nil and opts.password ~= "" then
      cmd = "sshpass -p '" .. opts.password .. "' " .. desktop_remote_setup[tool].cmd
    end

    cmd = cmd .." " .. desktop_remote_setup[tool].opt .. " " .. "rdp://" .. opts.username .. "@" .. opts.hostname
    async_cmd({commands = { cmd }, opts = { timeout = 0 } })
  end

  return true
end

-- @brief: setup
-- @description: setup ssh feature, this should be called in init.vim / init.lua
-- @usage: lua require('features.ssh').Setup()
local function setup()
	ssh_keymap_setting()
	ssh_read_json()

	vim.cmd("command! -nargs=0 SshReq lua require('features.ssh').SshConnectReq()")
	vim.cmd("command! -nargs=0 Ssh lua require('features.ssh').SshRun()")
	vim.cmd("command! -nargs=0 SshList lua require('features.ssh').SshList(true)")
	vim.cmd("command! -nargs=1 SshGetInfo lua print(vim.inspect(require('features.ssh').SshGetInfo(<q-args>)))")
	vim.cmd("command! -nargs=0 SshCopy lua require('features.ssh').SshCopy()")
	vim.cmd("command! -nargs=0 SshSftp lua require('features.ssh').SshSftp()")
  vim.cmd("command! -nargs=0 SshDesktop lua require('features.ssh').SshDesktop()")
end

return {
	Setup = setup,
	SshConnect = ssh_connect,
	SshConnectReq = ssh_connect_request,
	SshRun = ssh_run,
	SshInsertInfo = ssh_insert_info,
	SshList = ssh_get_list,
  SshGetInfo = get_ssh_info_by_name,
	SshTogglePwrsh = toggle_powershell_ssh,
	SshToggleSshpass = toggle_sshpass,
  SshCopy = secure_copy,
  SshSendFile = secure_copy,
  SshSftp = secret_file_transfer,
  SshDesktop = connect_ssh_desktop,
}
