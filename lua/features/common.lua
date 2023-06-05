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

local function display_tittle(tittle)
	local display_msg = string.format("%4s", tittle)

	display_delimited_line()
	print(display_msg)
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

	display_tittle(" Group List")

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

local ret = {
	DisplayDelimitedLine = display_delimited_line,
	DisplayTittle = display_tittle,
	GroupSelection = group_selection,
}

return ret
