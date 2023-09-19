local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local bookmarks_dir = vim.fn.stdpath('data') .. delim .. 'bookmarks'
local bookmarks_json_file = bookmarks_dir .. delim .. 'bookmarks.json'
local BookMarks = {}
BookMarks = {}
local bookmarks_qf_title = "bookmarks"

local function load_qf_bookmark_keymap()
	vim.api.nvim_buf_set_keymap(0, 'n', 'dd',
		[[<cmd> lua require('features.bookmarks').Remove() <CR>]], { silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', '<Tab>',
		[[<cmd> lua require('features.bookmarks').Review() <CR>]], { silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', 'c',
		[[<cmd> lua require('features.bookmarks').Rename() <CR>]], { silent = true })
end

local function get_same_path_bookmarks(filepath)
	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}
	local items = {}

	for _, v in ipairs(BookMarks) do
		if v.filename == filepath then
			table.insert(items, v)
		end
	end

	return items
end

local function save_bookmark()
	local filename = vim.fn.expand('%:p')

	if filename == '' then
		return {}
	end

	local bookmark = vim.fn.input('Enter bookmark: ')

	if bookmark == '' then
		return {}
	end

	if bookmark == ' ' then
		bookmark = vim.fn.getline('.')
	end

	local item, items = {}, {}
	local content = vim.fn.getline('.')

	item.filename = filename
	item.text = bookmark
	item.lnum = vim.fn.line('.')
	item.col = vim.fn.col('.')
	item.type = 'b'
	item.bufnr = nil

	if vim.bo.filetype ~= 'qf' then
		item.content = content
	end

	for i, v in ipairs(BookMarks) do
		if v.lnum == item.lnum and v.filename == item.filename then
			goto continue
		end

		table.insert(items, v)
		::continue::
	end

	table.insert(items, item)
	BookMarks = items
	require('features.system').SetJsonFile(BookMarks, bookmarks_json_file)

	return BookMarks
end

local function load_local_bookmarks(row, col)
	local qf_title = vim.fn.getqflist({ title = 0 }).title

	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	if #BookMarks == 0 then
		if qf_title == bookmarks_qf_title then
			vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })

			if vim.bo.filetype == 'qf' then
				vim.cmd("silent! copen")
			end
		end

		return
	end

	local current_working_directory = vim.fn.getcwd()
	local items = {}

	for _, v in ipairs(BookMarks) do
		if string.match(v.filename, current_working_directory) then
			table.insert(items, v)
		end
	end

	table.sort(items, function(a, b)
		return a.filename < b.filename
	end)

	local same_file_items = {}
	local current_file_items = {}

	for _, v in ipairs(items) do
		if v.filename == vim.fn.expand('%:p') then
			table.insert(same_file_items, v)
		else
			table.insert(current_file_items, v)
		end
	end

	if #same_file_items > 0 then
		table.sort(same_file_items, function(a, b)
			return a.lnum < b.lnum
		end)
	end

	local action = ' '

	if qf_title == bookmarks_qf_title then
		action = 'r'
	end

	vim.fn.setqflist({}, action,
		{ title = bookmarks_qf_title, items = same_file_items })
	vim.fn.setqflist({}, 'a',
		{ title = bookmarks_qf_title, items = current_file_items })
	vim.cmd("silent! copen")

	load_qf_bookmark_keymap()

	if row ~= nil and col ~= nil then
		vim.fn.cursor(row, col)
	end
end

local function load_bookmarks(row, col)
	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	local qf_title = vim.fn.getqflist({ title = 0 }).title
	local items = BookMarks
	local filename = vim.fn.expand('%:p')

	if #items == 0 then
		if qf_title == bookmarks_qf_title then
			vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })

			if vim.bo.filetype == 'qf' then
				vim.cmd("silent! copen")
			end
		end

		return
	end

	if vim.bo.filetype == 'qf' then
		if qf_title == bookmarks_qf_title then
			local qf_items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items
			row = row ~= nil and row or vim.fn.line('.')
			col = col ~= nil and col or vim.fn.col('.')


			if row <= #qf_items then
				filename = vim.api.nvim_buf_get_name(qf_items[row].bufnr)
			end
		end
	end

	table.sort(items, function(a, b)
		return a.filename < b.filename
	end)

	local same_file_items = {}
	local current_file_items = {}

	for _, v in ipairs(items) do
		if v.filename == filename then
			table.insert(same_file_items, v)
		else
			table.insert(current_file_items, v)
		end
	end

	if #same_file_items > 0 then
		table.sort(same_file_items, function(a, b)
			return a.lnum < b.lnum
		end)
	end

	local action = ' '

	if qf_title == bookmarks_qf_title then
		action = 'r'
	end

	vim.fn.setqflist({}, action,
		{ title = bookmarks_qf_title, items = same_file_items })
	vim.fn.setqflist({}, 'a',
		{ title = bookmarks_qf_title, items = current_file_items })
	vim.cmd("silent! copen")

	load_qf_bookmark_keymap()

	if row ~= nil and col ~= nil then
		vim.fn.cursor(row, col)
	end
end

local function rename_bookmark()
	local filename = vim.fn.expand('%:p')
	local lnum = vim.fn.line('.')
	local items = {}

	if vim.bo.filetype == 'qf' then
		local qf_title = vim.fn.getqflist({ title = 0 }).title
		local qf_index = lnum

		if qf_title ~= bookmarks_qf_title then
			return
		end

		items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items
		filename = vim.api.nvim_buf_get_name(items[qf_index].bufnr)
		lnum = items[qf_index].lnum
	else
		local found_bookmark = false
		items = get_same_path_bookmarks(filename)

		if #items == 0 then
			return
		end

		for _, v in ipairs(items) do
			if v.lnum == lnum then
				found_bookmark = true
				break
			end
		end

		if found_bookmark == false then
			return
		end
	end

	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	if #BookMarks == 0 then
		return
	end

	for i, v in ipairs(BookMarks) do
		if v.lnum == lnum and v.filename == filename then
			local bookmark = vim.fn.input('Update bookmark: ', v.text)

			if bookmark ~= '' then
				v.text = bookmark
				require('features.system').SetJsonFile(BookMarks, bookmarks_json_file)
			end

			break;
		end
	end

	local row, col = vim.fn.line('.'), vim.fn.col('.')

	if vim.bo.filetype == 'qf' then
		if #items < #BookMarks then
			load_local_bookmarks(row, col)
		else
			load_bookmarks(row, col)
		end
	end
end

local function remove_bookmark_in_buffer()
	local items = {}
	local filename = vim.fn.expand('%:p')
	local current_line = vim.fn.line('.')
	local remove_bookmark_content = nil

	if vim.bo.filetype == 'qf' or filename == '' then
		return
	end

	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	for _, v in ipairs(BookMarks) do
		if v.lnum == current_line and v.filename == filename then
			remove_bookmark_content = v.text
			goto continue
		end

		table.insert(items, v)
		::continue::
	end

	if remove_bookmark_content == nil then
		return
	end

	local prefix_string = string.format("[ X %s] ", bookmarks_qf_title)
	local display_string = string.format("%s%s", prefix_string, remove_bookmark_content)
	vim.api.nvim_echo({{ display_string }}, false, {})

	BookMarks = items
	require('features.system').SetJsonFile(BookMarks, bookmarks_json_file)
end

local function remove_bookmark()
	if vim.bo.filetype ~= 'qf' then
		remove_bookmark_in_buffer()
		return
	else
		local qf_title = vim.fn.getqflist({ title = 0 }).title

		if qf_title ~= bookmarks_qf_title then
			return
		end
	end

	local items = {}
	local qf_items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items

	if #qf_items == 0 then
		vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })
		return
	end

	local qf_index = vim.fn.line('.')
	local remove_item = qf_items[qf_index]
	local remove_filename = ''

	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	for _, v in ipairs(BookMarks) do
		if v.lnum == remove_item.lnum then
			if remove_item.bufnr ~= nil then
				remove_filename = vim.api.nvim_buf_get_name(remove_item.bufnr)
			else
				remove_filename = remove_item.filename
			end

			if v.filename == remove_filename then
				goto continue
			end
		end

		table.insert(items, v)
		::continue::
	end

	local row, col = vim.fn.line('.'), vim.fn.col('.')
	local is_local_bookmarks = #qf_items < #BookMarks
	BookMarks = items
	require('features.system').SetJsonFile(BookMarks, bookmarks_json_file)

	row = row > 0 and row or  1
	col = col > 0 and col or 1

	if is_local_bookmarks == true then
		load_local_bookmarks(row, col)
	else
		load_bookmarks(row, col)
	end
end

;
local function clear_local_bookmarks()
	local current_working_directory = vim.fn.getcwd()
	local items = {}

	for _, v in ipairs(BookMarks) do
		if string.match(v.filename, current_working_directory) == nil then
			table.insert(items, v)
		end
	end

	BookMarks = items
end

local function next_bookmark()
	local filename = vim.fn.expand('%:p')
	local items = get_same_path_bookmarks(filename)

	if #items == 0 then
		return
	end

	local current_line, last_line = vim.fn.line('.'), vim.fn.line('$')
	local next_row, next_col = last_line, 0
	local wrap_row, wrap_col = current_line, 0
	local next_msg, wrap_msg, current_line_msg = '', '', ''

	for _, v in ipairs(items) do
		if filename ~= v.filename then
			goto continue
		end

		if v.lnum > current_line and v.lnum <= next_row then
			next_row = v.lnum
			next_col = v.col
			next_msg = v.text
		elseif v.lnum < current_line and v.lnum < wrap_row then
			wrap_row = v.lnum
			wrap_col = v.col
			wrap_msg = v.text
		elseif v.lnum == current_line then
			current_line_msg = v.text
		end

		::continue::
	end

	local wrap_around = (next_row == last_line) and (next_col == 0) and (wrap_col > 0)
	local only_bookmark_at_current_line = (next_col == 0)

	if wrap_around == true then
		next_row, next_col = wrap_row, wrap_col
		next_msg = wrap_msg
	elseif only_bookmark_at_current_line == true then
		next_row, next_col = current_line, vim.fn.col('.')
		next_msg = current_line_msg
	end

	vim.fn.cursor(next_row, next_col)
	next_msg = string.format("[%s] %s", bookmarks_qf_title, next_msg)
	vim.api.nvim_echo({ { next_msg } }, false, {})
end

local function prev_bookmark()
	local filename = vim.fn.expand('%:p')
	local items = get_same_path_bookmarks(filename)

	if #items == 0 then
		return
	end

	local current_line, first_line = vim.fn.line('.'), 1
	local prev_row, prev_col = first_line, 0
	local wrap_row, wrap_col = current_line, 0
	local prev_msg, wrap_msg, current_line_msg = '', '', ''

	for _, v in ipairs(items) do
		if filename ~= v.filename then
			goto continue
		end

		if v.lnum < current_line and v.lnum >= prev_row then
			prev_row = v.lnum
			prev_col = v.col
			prev_msg = v.text
		elseif v.lnum > current_line and v.lnum > wrap_row then
			wrap_row = v.lnum
			wrap_col = v.col
			wrap_msg = v.text
		elseif v.lnum == current_line then
			current_line_msg = v.text
		end

		::continue::
	end

	local wrap_around = (prev_row == first_line) and (prev_col == 0) and (wrap_col > 0)
	local only_bookmark_at_current_line = (prev_col == 0)

	if wrap_around == true then
		prev_row, prev_col = wrap_row, wrap_col
		prev_msg = wrap_msg
	elseif only_bookmark_at_current_line == true then
		prev_row, prev_col = current_line, vim.fn.col('.')
		prev_msg = current_line_msg
	end

	vim.fn.cursor(prev_row, prev_col)
	prev_msg = string.format("[%s] %s", bookmarks_qf_title, prev_msg)
	vim.api.nvim_echo({ { prev_msg } }, false, {})
end

local function review_bookmark_content()
	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}

	if #BookMarks == 0 then
		return
	end

	local filename = ''
	local lnum = vim.fn.line('.')

	if vim.bo.filetype == 'qf' then
		if vim.fn.getqflist({ title = 0 }).title ~= bookmarks_qf_title then
			return
		end

		local qf_items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items
		local qf_index = vim.fn.line('.')

		filename = vim.api.nvim_buf_get_name(qf_items[qf_index].bufnr)
		lnum = qf_items[qf_index].lnum
	else
		filename = vim.fn.expand('%:p')
		lnum = vim.fn.line('.')
	end

	for _, v in ipairs(BookMarks) do
		if filename == v.filename and lnum == v.lnum then
			vim.api.nvim_echo({ { v.content } }, false, {})
			break
		end
	end
end

local function setup()
	if vim.fn.isdirectory(bookmarks_dir) == 0 then
		vim.fn.mkdir(bookmarks_dir, 'p')
	end

	if vim.fn.filereadable(bookmarks_json_file) == 0 then
		vim.fn.writefile({}, bookmarks_json_file)
	end

	BookMarks = require('features.system').GetJsonFile(bookmarks_json_file) or {}
end

return {
	Setup = setup,
	Save = save_bookmark,
	Get = load_local_bookmarks,
	GetAll = load_bookmarks,
	Rename = rename_bookmark,
	Remove = remove_bookmark,
	Review = review_bookmark_content,
	Clear = clear_local_bookmarks,
	Next = next_bookmark,
	Prev = prev_bookmark
}
