local todo_repo_name = "todo"
local todo_list_title = 'Todo List'
local todo_lists = {create_file_location = nil, filename = nil, type = nil}

local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local todo_lists_path = vim.fn.stdpath('data') .. delim .. 'todo'
local todo_list_json = todo_lists_path .. delim .. 'todo_list.json'
-- todo list item prefix and icon display on quickfix window
-- n: new, d: done, p: pending, x: cancel
local todo_prefix = {['n'] = '[ ]', ['d'] = '[V]', ['p'] = '[-]', ['x'] = '[x]'}
-- toggle todo status sequence: n -> d -> p -> x -> n
local todo_prefix_sequence = {
    ['n'] = 'd',
    ['d'] = 'p',
    ['p'] = 'x',
    ['x'] = 'n'
}
local todo_lists_autocmd_id = {}
-- @brief Remove todo list autocmd id
local function remove_todo_lists_autocmd_id(bufnr)
    if todo_lists_autocmd_id[bufnr] ~= nil then
        vim.api.nvim_del_autocmd(todo_lists_autocmd_id[bufnr])
        todo_lists_autocmd_id[bufnr] = nil

        return true
    end

    return false
end

-- @brief Add keymapping to todo list in quickfix window
-- @return nil
local function add_todo_keymapping()
    if vim.bo.filetype ~= 'qf' then return end

    if vim.fn.getqflist({title = 0}).title ~= todo_list_title then return end

    local key_setup = {
        {key = '<Tab>', cmd = ':lua require("features.todo").Toggle()<CR>'},
        {key = 'w', cmd = ':lua require("features.todo").Add()<CR>'},
        {key = 'r', cmd = ':lua require("features.todo").Update()<CR>'},
        {key = '<CR>', cmd = ':lua require("features.todo").Read()<CR>'},
        {key = 'dd', cmd = ':lua require("features.todo").Remove()<CR>'}
    }

    for _, v in ipairs(key_setup) do vim.api.nvim_buf_set_keymap(0, 'n', v.key, v.cmd, {
        silent = true
    }) end
end

-- @brief Add todo list
-- @description Create a new todo list as file and records as json member in todo_list.json
--              open the file in a new split window
--              Sort todo list by filename in descending order and completed items at the end
-- @return nil
local function add_todo_list()
    local name = 'todo_' .. os.date('%y%m%d_%H%M%S')
    local file_path = todo_lists_path .. delim .. name
    local file = io.open(file_path, 'w')

    if file == nil then
        vim.api.nvim_echo({
            {'Error: Could not create file: ' .. file_path, 'ErrorMsg'}
        }, true, {})
        return
    end

    io.close(file)
    vim.cmd('5split ' .. file_path)

    table.insert(todo_lists, {
        create_file_location = vim.fn.expand('%:p'),
        filename = vim.fn.fnamemodify(file_path, ':t'),
        type = 'n' -- n: new
    })

    table.sort(todo_lists, function(a, b) return a.filename > b.filename end)

    local done_items, items = {}, {}

    for _, v in ipairs(todo_lists) do table.insert((v.type == 'd' and done_items or items), v) end

    for _, v in ipairs(done_items) do table.insert(items, v) end

    todo_lists = items

    if require('features.files').SetJson(todo_lists, todo_list_json) == true then
        require('features.git').UpdateVimDataRepo(todo_repo_name)
    end
end

-- @brief Read todo list
local function read_todo_list()
    if vim.bo.filetype ~= 'qf' then return end

    local qf_title = vim.fn.getqflist({title = 0}).title

    if qf_title ~= todo_list_title then return end

    local qf_index = vim.fn.line('.')
    local qf_col = vim.fn.col('.')

    if qf_index > #todo_lists or qf_index == 0 then return end

    local todo_list = todo_lists[qf_index]

    if todo_list == nil then return end

    local file_path = todo_lists_path .. delim .. todo_list.filename

    if vim.fn.filereadable(file_path) == 0 then return end

    vim.cmd('view ' .. file_path)

    local autocmd_id = vim.api.nvim_create_autocmd({"BufDelete"}, {
        callback = function()
            local bufnr = vim.fn.bufnr("%")

            if require('features.todo').RemoveAutoCmdId(bufnr) == false then return end

            require('features.todo').Get()
            vim.fn.cursor(qf_index, qf_col)
        end
    })

    local bufnr = vim.fn.bufnr("%")
    todo_lists_autocmd_id[bufnr] = {
        id = autocmd_id,
        row = qf_index,
        col = qf_col
    }
end

-- @brief Get todo list
-- @return todo list
local function get_todo_list()
    local lists, items = {}, {}
    local file, text, file_path

    for _, v in ipairs(todo_lists) do
        file_path = todo_lists_path .. delim .. v.filename
        file = io.open(file_path, 'r')

        if file == nil then goto continue end

        text = file:read("*l")
        io.close(file)

        if text == nil or text == '' then
            os.remove(file_path)
            goto continue
        end

        if todo_prefix[v.type] == nil then v.type = 'n' end

        text = todo_prefix[v.type] .. ' ' .. text
        table.insert(lists, v)
        table.insert(items, {filename = nil, text = text, type = v.type})

        ::continue::
    end

    todo_lists = lists

    local qf_title = vim.fn.getqflist({title = 0}).title
    local action = ' '

    if qf_title == todo_list_title then action = 'r' end

    if #items > 0 then
        vim.fn.setqflist({}, action, {title = todo_list_title, items = items})

        if vim.bo.filetype ~= 'qf' then
            vim.cmd('silent! copen')
        else
            vim.fn.cursor(vim.fn.line('.'), vim.fn.col('.'))
        end

        add_todo_keymapping()
    elseif vim.bo.filetype == 'qf' and qf_title == todo_list_title then
        vim.cmd('silent! cclose')
        vim.fn.setqflist({}, 'r', {title = todo_list_title, items = {}})
    end

    return lists
end

-- @brief Toggle todo list item
-- @return nil
local function toggle_todo_list()
    if vim.bo.filetype ~= 'qf' then return end

    local qf_title = vim.fn.getqflist({title = 0}).title

    if qf_title ~= todo_list_title then return end

    local qf_index = vim.fn.line('.')
    local qf_col = vim.fn.col('.')

    if qf_index > #todo_lists or qf_index == 0 then return end

    local todo_list = todo_lists[qf_index]

    if todo_list == nil then return end

    local toggle = todo_prefix_sequence[todo_list.type]
    todo_list.type = toggle

    local items = {}

    for i, v in ipairs(todo_lists) do
        if i == qf_index then v.type = todo_list.type end

        table.insert(items, v)
    end

    todo_lists = items

    if require('features.files').SetJson(todo_lists, todo_list_json) == true then
        require('features.git').UpdateVimDataRepo(todo_repo_name)
    end

    get_todo_list()
    vim.fn.cursor(qf_index, qf_col)
end

local function remove_todo_list()
    if vim.bo.filetype ~= 'qf' then return end

    local qf_title = vim.fn.getqflist({title = 0}).title

    if qf_title ~= todo_list_title then return end

    local qf_index = vim.fn.line('.')
    local qf_col = vim.fn.col('.')

    if qf_index == 0 and #todo_lists > 0 then return end

    if qf_index >= #todo_lists then
        table.remove(todo_lists)
    else
        local items = {}

        for i, v in ipairs(todo_lists) do if i ~= qf_index then table.insert(items, v) end end

        todo_lists = items
    end

    if require('features.files').SetJson(todo_lists, todo_list_json) == true then
        require('features.git').UpdateVimDataRepo(todo_repo_name)
    end

    get_todo_list()
    vim.fn.cursor(qf_index, qf_col)
end

local function update_todo_list()
    local qf_index, qf_col = vim.fn.line('.'), vim.fn.col('.')

    get_todo_list()

    if vim.bo.filetype ~= 'qf' then return end

    local qf_title = vim.fn.getqflist({title = 0}).title

    if qf_title ~= todo_list_title then return end

    if qf_index > #todo_lists or qf_index == 0 then return end

    local todo_list = todo_lists[qf_index]

    if todo_list == nil then return end

    local file_path = todo_lists_path .. delim .. todo_list.filename

    if vim.fn.filereadable(file_path) == 0 then return end

    vim.cmd('edit ' .. file_path)

    local autocmd_id = vim.api.nvim_create_autocmd({"BufDelete"}, {
        callback = function()
            local bufnr = vim.fn.bufnr("%")

            if require('features.todo').RemoveAutoCmdId(bufnr) == false then return end

            require('features.todo').Get()
            vim.fn.cursor(qf_index, qf_col)
        end
    })

    local bufnr = vim.fn.bufnr("%")
    todo_lists_autocmd_id[bufnr] = {
        id = autocmd_id,
        row = qf_index,
        col = qf_col
    }
end

-- @brief Setup todo list
-- @details:
--     1. Create todo list directory if not exists
--     2. Create todo list json file if not exists
--     3. Load todo list json file
--     4. Sort Done items from todo list after processing todo list
--     4. Set todo list as global variable
--     5. Update todo list json file
-- @return nil
local function setup()
    if vim.fn.filereadable(vim.fn.expand(todo_list_json)) == 0 then return end

    todo_lists = require('features.files').GetJson(todo_list_json) or {}

    local done_items = {}
    local items = {}

    for _, v in ipairs(todo_lists) do table.insert((v.type == 'd' and done_items or items), v) end

    for _, v in ipairs(done_items) do table.insert(items, v) end

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
    Update = update_todo_list
}
