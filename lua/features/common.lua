local function display_delimited_line(delimited_character)
	local current_window = vim.api.nvim_get_current_win()
	local window_width = vim.api.nvim_win_get_width(current_window)
	local delimited_mark = tostring(delimited_character or "=")
	local delimited_len = window_width - 10
	local display_msg = ""

	for _ = 1, delimited_len do
		display_msg = display_msg .. delimited_mark
	end

	print(display_msg)
end

local function display_seperate_line_on_count(idx, seperator_count)
		if idx % seperator_count == 0 then
			if idx % (seperator_count * 2) == 0 then
				display_delimited_line("~")
			else
				display_delimited_line("-")
			end
		end
end

local function display_title(tittle)
	local current_window = vim.api.nvim_get_current_win()
	local window_width = vim.api.nvim_win_get_width(current_window)
	local string_len = string.len(tittle)
	local padding_len = math.floor((window_width - string_len) / 2)

	display_delimited_line()
	vim.api.nvim_echo({{
		string.format("%" .. padding_len .. "s", tittle),
		"WarningMsg"}}, true, {})
	display_delimited_line()
end

local function group_selection(tbl)
	local group_list = {}
	local group_total = 0

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
				table.insert(group_list, info.group)
				group_total = group_total + 1
				break
			end

			cnt = cnt + 1
		until (cnt - 1) > group_total
	end

	display_title(" Group List")

	for idx, grp in ipairs(group_list) do
		print(string.format("%3d| %s", idx, grp))
	end

	local sel_idx = tonumber(vim.fn.input("Enter number to select group: "))
	local sel_grp = group_list[sel_idx]

	if sel_grp == nil then
		vim.api.nvim_echo({{"\nInvalid selection", "WarningMsg"}}, false, {})
		return
	end

	vim.api.nvim_echo({{"\t[ " .. sel_grp .. " ]\n", "none"}}, false, {})

	return sel_grp
end

local function table_selection(tbl, name)
	display_title(name)

	for idx, info in ipairs(tbl) do
		vim.api.nvim_echo({
			{string.format("%3d| %s", idx, info), "none"}
		}, true, {})

		display_seperate_line_on_count(idx, 2)
	end

	local sel_idx = tonumber(vim.fn.input("Enter number to select: "))
	local sel_tbl = tbl[sel_idx]

	if sel_tbl == nil then
		vim.api.nvim_echo({
			{"\nInvalid selection", "WarningMsg"}
		}, false, {})
		return vim.loop.cwd()
	end

	vim.api.nvim_echo({
		{"\t[ " .. sel_tbl .. " ]\n", "none"}
	}, false, {})

	return sel_tbl
end

local ret = {
	DisplayDelimitedLine = display_delimited_line,
	DisplayTitle = display_title,
	GroupSelection = group_selection,
	TableSelection = table_selection,
}

return ret
