local todo_list_title = 'Todo List'
local todo_lists = {
	create_file_location = nil,
	filename = nil,
	type = nil
}

local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local todo_lists_path = vim.fn.stdpath('data') .. delim .. 'todo'
local todo_list_json = todo_lists_path .. delim .. 'todo_list.json'
local todo_prefix = {
	['n'] = '[ ]',
	['d'] = '[V]',
	['p'] = '[-]',
	['x'] = '[x]',
}
local todo_prefix_sequence = {
	['n'] = 'd',
	['d'] = 'p',
	['p'] = 'x',
	['x'] = 'n',
}
local todo_lists_autocmd_id = {}

local function remove_todo_lists_autocmd_id(bufnr)
	if todo_lists_autocmd_id[bufnr] ~= nil then
		vim.api.nvim_del_autocmd(todo_lists_autocmd_id[bufnr])
		todo_lists_autocmd_id[bufnr] = nil

		return true
	end

	return false
end

local function add_todo_keymapping()
	if vim.bo.filetype ~= 'qf' then
		return
	end

	if vim.fn.getqflist({ title = 0 }).title ~= todo_list_title then
		return
	end

	vim.api.nvim_buf_set_keymap(0, 'n', '<Tab>',
		'<cmd>:lua require("features.todo").Toggle()<CR>', {silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', 'w',
		'<cmd>lua require("features.todo").Add()<CR>', { silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', 'r',
		'<cmd>lua require("features.todo").Update()<CR>', { silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', '<CR>',
		'<cmd>lua require("features.todo").Read()<CR>', { silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', 'dd',
		'<cmd>lua require("features.todo").Remove()<CR>', { silent = true })
end

local function add_todo_list()
	local name = 'todo_' .. os.date('%y%m%d_%H%M%S')
	local filename = todo_lists_path .. delim .. name
	local file = io.open(filename, 'w')

	if file == nil then
		vim.api.nvim_echo({
			{'Error: Could not create file: ' .. filename,
			'ErrorMsg'}}, true, {})
		return
	end

	io.close(file)

	vim.cmd('5split ' .. filename)

	table.insert(todo_lists, {
		create_file_location = vim.fn.expand('%:p'),
		filename = filename,
		type = 'n',
	})

	table.sort(todo_lists, function(a, b)
		return a.filename > b.filename
	end)

	local done_items = {}
	local items = {}

	for _, v in ipairs(todo_lists) do
		if v.type == 'd' then
			table.insert(done_items, v)
		else
			table.insert(items, v)
		end
	end

	for _, v in ipairs(done_items) do
		table.insert(items, v)
	end

	todo_lists = items


	 require('features.files').SetJson(todo_lists, todo_list_json)
end

local function read_todo_list()
	if vim.bo.filetype ~= 'qf' then
		return
	end

	local qf_title = vim.fn.getqflist({ title = 0 }).title

	if qf_title ~= todo_list_title then
		return
	end

	local qf_index = vim.fn.line('.')
	local qf_col = vim.fn.col('.')

	if qf_index > #todo_lists or qf_index == 0 then
		return
	end

	local todo_list = todo_lists[qf_index]

	if todo_list == nil then
		return
	end

	if vim.fn.filereadable(todo_list.filename) == 0 then
		return
	end

	vim.cmd('view ' .. todo_list.filename)

	local autocmd_id = vim.api.nvim_create_autocmd({"BufDelete"}, {
		callback = function()
			local bufnr = vim.fn.bufnr("%")

			if require('features.todo').RemoveAutoCmdId(bufnr) == false then
				return
			end

			require('features.todo').Get()
			vim.fn.cursor(qf_index, qf_col)
		end
	})

	local bufnr = vim.fn.bufnr("%")
	todo_lists_autocmd_id[bufnr] = {
		id = autocmd_id,
		row = qf_index,
		col = qf_col,
	}
end

local function get_todo_list()
	local lists, items = {}, {}
	local file, text

	for _, v in ipairs(todo_lists) do
		file = io.open(v.filename, 'r')

		if file == nil then
			goto continue
		end

		text = file:read("*l")
		io.close(file)

		if text == nil or text == '' then
			os.remove(v.filename)
			goto continue
		end

		if todo_prefix[v.type] == nil then
			v.type = 'n'
		end

		text = todo_prefix[v.type] .. ' ' .. text
		table.insert(lists, v)
		table.insert(items, {
			filename = nil,
			text = text,
			type = v.type,
		})

		::continue::
	end

	todo_lists = lists

	local qf_title = vim.fn.getqflist({ title = 0 }).title
	local action = ' '

	if qf_title == todo_list_title then
		action = 'r'
	end

	if #items > 0 then
		vim.fn.setqflist({}, action, {
			title = todo_list_title,
			items = items,
		})

		if vim.bo.filetype ~= 'qf' then
			vim.cmd('silent! copen')
		else
			vim.fn.cursor(vim.fn.line('.'), vim.fn.col('.'))
		end

		add_todo_keymapping()
	elseif vim.bo.filetype == 'qf' and qf_title == todo_list_title then
			vim.cmd('silent! cclose')
			vim.fn.setqflist({}, 'r', {
				title = todo_list_title,
				items = {},
			})
	end

	return lists
end

local function toggle_todo_list()
	if vim.bo.filetype ~= 'qf' then
		return
	end

	local qf_title = vim.fn.getqflist({ title = 0 }).title

	if qf_title ~= todo_list_title then
		return
	end

	local qf_index = vim.fn.line('.')
	local qf_col = vim.fn.col('.')

	if qf_index > #todo_lists or qf_index == 0 then
		return
	end

	local todo_list = todo_lists[qf_index]

	if todo_list == nil then
		return
	end

	local toggle = todo_prefix_sequence[todo_list.type]
	todo_list.type = toggle

	local items = {}

	for i, v in ipairs(todo_lists) do
		if i == qf_index then
			v.type = todo_list.type
		end

		table.insert(items, v)
	end

	todo_lists = items
	require('features.files').SetJson(todo_lists, todo_list_json)
	get_todo_list()
	vim.fn.cursor(qf_index, qf_col)
end

local function remove_todo_list()
	if vim.bo.filetype ~= 'qf' then
		return
	end

	local qf_title = vim.fn.getqflist({ title = 0 }).title

	if qf_title ~= todo_list_title then
		return
	end

	local qf_index = vim.fn.line('.')
	local qf_col = vim.fn.col('.')

	if qf_index == 0 and #todo_lists > 0 then
		return
	end

	if qf_index >= #todo_lists then
		table.remove(todo_lists)
	else
		local items = {}

		for i, v in ipairs(todo_lists) do
			if i ~= qf_index then
				table.insert(items, v)
			end
		end

		todo_lists = items
	end

	require('features.files').SetJson(todo_lists, todo_list_json)
	get_todo_list()
	vim.fn.cursor(qf_index, qf_col)
end

local function update_todo_list()
	local qf_index = vim.fn.line('.')
	local qf_col = vim.fn.col('.')

	get_todo_list()

	if vim.bo.filetype ~= 'qf' then
		return
	end

	local qf_title = vim.fn.getqflist({ title = 0 }).title

	if qf_title ~= todo_list_title then
		return
	end

	if qf_index > #todo_lists or qf_index == 0 then
		return
	end

	local todo_list = todo_lists[qf_index]

	if todo_list == nil then
		return
	end

	if vim.fn.filereadable(todo_list.filename) == 0 then
		return
	end

	vim.cmd('edit ' .. todo_list.filename)

	local autocmd_id = vim.api.nvim_create_autocmd({"BufDelete"}, {
		callback = function()
			local bufnr = vim.fn.bufnr("%")

			if require('features.todo').RemoveAutoCmdId(bufnr) == false then
				return
			end

			require('features.todo').Get()
			vim.fn.cursor(qf_index, qf_col)
		end
	})

	local bufnr = vim.fn.bufnr("%")
	todo_lists_autocmd_id[bufnr] = {
		id = autocmd_id,
		row = qf_index,
		col = qf_col,
	}
end


local function setup()
	if vim.fn.filereadable(vim.fn.expand(todo_list_json)) == 0 then
		vim.fn.mkdir(todo_lists_path, 'p')
		vim.fn.writefile({}, todo_list_json)
	end

	 todo_lists = require('features.files').GetJson(todo_list_json) or {}

	local done_items = {}
	local items = {}

	for _, v in ipairs(todo_lists) do
		if v.type == 'd' then
			table.insert(done_items, v)
		else
			table.insert(items, v)
		end
	end

	for _, v in ipairs(done_items) do
		table.insert(items, v)
	end

	todo_lists = items

	require('features.files').SetJson(todo_lists, todo_list_json)
end

return {
	Setup = setup,
	Add = add_todo_list,
	Get = get_todo_list,
	Read = read_todo_list,
	Remove = remove_todo_list,
	RemoveAutoCmdId = remove_todo_lists_autocmd_id,
	Toggle = toggle_todo_list,
	Update = update_todo_list,
}
