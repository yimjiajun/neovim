local function display_title(title)
	vim.api.nvim_echo({{string.format("%-s", title), "Title"}}, true, {})
end

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

	if sel == 0
	then
		return nil
	end

	local sel_grp = group_list[sel]

	vim.api.nvim_echo({
		{"\t[ " .. sel_grp .. " ]\n", "WarningMsg"}
	}, false, {})

	return sel_grp
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
local function async_command(cmd, timeout_sec, sub_cmd)
  -- Function to strip surrounding quotes from a string
  local function strip_quotes(s)
    if (s:sub(1, 1) == '"' and s:sub(-1) == '"') or (s:sub(1, 1) == "'" and s:sub(-1) == "'") then
      return s:sub(2, -2)
    else
      return s
    end
  end
  local handle = nil
  local timeout = 30000 -- default: 30 seconds
  -- Split the command string into parts
  local parts = vim.split(strip_quotes(vim.fn.trim(cmd)), "%s+")
  -- Extract the command (first element)
  local command = table.remove(parts, 1)
  -- The remaining parts are the arguments
  local args = parts
  -- Create pipes for stdout and stderr
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  -- Define the on_exit callback
  local function on_exit(code, _)
    local status_msg = "Failed"

    if code == 0 then
      status_msg = "Succeeded"
    end

    print(status_msg .. " => [ " .. cmd .. " ]")
    stdout:close()
    stderr:close()

    if handle and not handle:is_closing() then
      handle:close()
    end

    cmd = nil -- remove exited command

    if code == 0 and sub_cmd ~= nil then
      async_command(sub_cmd, timeout, nil)
    end
  end
  -- Spawn the process
  handle = vim.loop.spawn(command, {
    args = args,
    stdio = {nil, stdout, stderr},
  }, vim.schedule_wrap(on_exit))
  -- Read from the pipes
  local function on_read(err, data)
    assert(not err, err)
    if data then
      print(data)
    end
  end
  stdout:read_start(on_read)
  stderr:read_start(on_read)
  -- Handle timeout
  if timeout_sec ~= nil then
    timeout = timeout_sec * 1000 -- convert seconds to ms
  end

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
      if cmd ~= nil then
        print("Timeout => [ " .. cmd .. " ]")
      end
    end
  end, timeout)
end

local function setup()
	return nil
end

return {
	DisplayTitle = display_title,
	GroupSelection = group_selection,
	TableSelection = table_selection,
  AsyncCommand = async_command,
	Setup = setup
}
