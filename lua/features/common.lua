local function display_delimited_line(delimited_character)
	local current_window = vim.api.nvim_get_current_win()
	local window_width = vim.api.nvim_win_get_width(current_window)
	local delimited_mark = tostring(delimited_character or "=")
	local delimited_len = window_width - 1
	local display_msg = ""

	for _ = 1, delimited_len do
		display_msg = display_msg .. delimited_mark
	end

	print(display_msg)
end

local function display_title(title)
	display_delimited_line()
	vim.api.nvim_echo({{
		string.format("%-s", title),
		"Title"}}, true, {})
	display_delimited_line()

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

local function setup()
	return nil
end

return {
	DisplayDelimitedLine = display_delimited_line,
	DisplayTitle = display_title,
	GroupSelection = group_selection,
	TableSelection = table_selection,
	Setup = setup
}
