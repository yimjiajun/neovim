local function display_title(title)
	vim.api.nvim_echo({{string.format("%-s", title), "Title"}}, false, {})
end

-- @name: group_selection
-- @description: select group from list
-- @param tbl: table of group list
-- @return: selected group
-- @usage: group_selection({{group = "Group1"}, {group = "Group2"}})
local function group_selection(tbl)
	local group_list = {}
	local group_total = 0

	if tbl == nil then
		return nil
	end

	table.sort(tbl, function(a, b)
		return a.group < b.group
	end)

	for _, info in ipairs(tbl) do
		local cnt = 1

		repeat
			if info.group == nil then
				break
			end

			if group_list[cnt] == info.group then
				break
			end

			if group_list[cnt] == nil then
				group_list[cnt] = info.group
				group_total = group_total + 1
				break
			end

			cnt = cnt + 1
		until (cnt - 1) > group_total
	end

	local lists = {}

	if #group_list == 0 then
		return nil
	end

	display_title("Group List")

	for idx, grps in ipairs(group_list) do
		lists[idx] = string.format("%2d. %s", idx, grps)
	end

	local sel = vim.fn.inputlist(lists)

	if sel == 0 or sel > #group_list then
		return nil
	end

	vim.api.nvim_echo({{"\t[ " .. group_list[sel] .. " ]\n", "WarningMsg"}}, false, {})
	return group_list[sel]
end

local function table_selection(tbl, display_lists, name)
	display_title(name)

	local s = vim.fn.inputlist(display_lists)

	if s == 0 then
		return
	end

	local sel_tbl = tbl[s]

	vim.api.nvim_echo({
		{"\t[ " .. sel_tbl .. " ]\n", "WarningMsg"}
	}, false, {})

	return sel_tbl
end

-- @name: async_command
-- @description: run command as async without blocking vim interface
-- @param cmd: command to run
-- @param timeout: timeout of running command in seconds
-- @param sub_cmd: command to run when primary command success
-- @return: nil
-- @usage: async_command("git log --oneline --graph --all")
-- @usage: async_command("ctags -R .", 120, "sort -u -o tags tags")
local function async_command(args)
  local opts = (args.opts == nil) and {} or args.opts
  local commands = (args.commands == nil) and nil or args.commands

  if commands == nil then
    vim.api.nvim_err_writeln("Not command is providing on AsyncCommand")
    return
  end

  commands = (type(commands) == "table") and commands or
            ((type(commands) == "string") and {commands} or { string.format("%s", commands) })
  local timeout = (opts.timeout == nil) and 30000 or (opts.timeout * 1000)-- default 30 seconds
  local handle = nil

  local function strip_quotes(s) -- Function to strip surrounding quotes from a string
    return
      ((s:sub(1, 1) == '"' and s:sub(-1) == '"') or (s:sub(1, 1) == "'" and s:sub(-1) == "'")) and s:sub(2, -2) or s
  end
  local parts = vim.split(strip_quotes(commands[1]), "%s+") -- Split the command string into parts
  local cmd = table.remove(parts, 1) -- Extract the command (first element)
  local cmd_args = parts -- The remaining parts are the arguments

  local function output_message(msg)
    if opts.silent == nil or opts.silent == false then
      print(msg)
    end
  end

  if vim.fn.executable(cmd) == 0 then
    output_message(string.format("%-10s [ %s ]", "Command Not Found", cmd))
    return
  end
  -- Create pipes for stdout and stderr
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  -- Define the on_exit callback
  local function on_exit(code, _)
    output_message(string.format("%-10s [ %s ] (Exit Code: %d)",
      (code == 0) and "Success" or "Failed", commands[1], code))

    if stdout and not stdout:is_closing() then
      stdout:close()
    end

    if stderr and not stderr:is_closing() then
      stderr:close()
    end

    if handle and not handle:is_closing() then
      handle:close()
    end

    if #commands >= 1 then
      table.remove(commands, 1)
    end

    if (#commands > 0) and (code == 0 or ((opts.allow_fail == nil) and false or opts.allow_fail)) then
      async_command({commands = commands, opts = opts})
    end
  end
  -- Spawn the process
  handle = vim.loop.spawn(cmd, {
    args = cmd_args,
    stdio = {nil, stdout, stderr}
  }, vim.schedule_wrap(on_exit))

  output_message(string.format("%-10s [ %s ]", "Execute", commands[1]))
  -- Read from the pipes
  local function on_read(err, data)
    assert(not err, err)

    if data then
      output_message(data)
    end
  end

  stdout:read_start(on_read)
  stderr:read_start(on_read)
  vim.defer_fn(function()
    if stdout and not stdout:is_closing() then
      stdout:close()
    end

    if stderr and not stderr:is_closing() then
      stderr:close()
    end

    if handle and not handle:is_closing() then
      handle:kill('sigterm')
      handle:close()
      -- cmd being nil when exited from running
      if #commands > 0 then
        output_message(string.format("%-10s [ %s ]", "TimeOut", commands[1]))
      end
    end
  end, timeout)
end

local function setup()
	vim.cmd("command! -nargs=+ AsyncCmd lua require('features.common').AsyncCommand(<f-args>)")
	return nil
end

return {
	DisplayTitle = display_title,
	GroupSelection = group_selection,
	TableSelection = table_selection,
  AsyncCommand = async_command,
	Setup = setup
}
