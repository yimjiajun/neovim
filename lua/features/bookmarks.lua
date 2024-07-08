local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local bookmarks_dir = vim.fn.stdpath('data') .. delim .. 'bookmarks'
local bookmarks_json_file = bookmarks_dir .. delim .. 'bookmarks.json'
local BookMarks = {}
local bookmarks_qf_title = "bookmarks"
local reserve_marks = { 'e', 'i', 'n', 'm', 'w' }

local function update_items_from_mark(items)
    for _, v in ipairs(items) do
        if v.type == nil or v.filename ~= vim.api.nvim_buf_get_name(0) then goto continue end

        local mark = vim.api.nvim_buf_get_mark(0, v.type)

        if mark[1] > 0 and mark[2] > 0 then v.lnum, v.col = mark[1], mark[2] end
        ::continue::
    end
end

local function sort_items_by_mark(items)
    if items == nil or #items == 0 then return end

    local type = string.byte('a')
    local marks_in_buffer = {}
    local new_marks = {}

    for _, m in ipairs(reserve_marks) do table.insert(marks_in_buffer, m) end

    for _, m in ipairs(items) do if m.type ~= nil then table.insert(marks_in_buffer, m.type) end end

    for _, v in ipairs(items) do
        while vim.tbl_contains(marks_in_buffer, string.char(type)) do type = type + 1 end

        if v.filename ~= vim.api.nvim_buf_get_name(0) then goto continue end

        if type >= string.byte('z') then
            v.type = nil
            goto continue
        end

        if v.type == nil then
            v.type = string.char(type)
            table.insert(new_marks, v.type)
            table.insert(marks_in_buffer, v.type)
            type = type + 1
        end

        ::continue::
    end

    for m = string.byte('a'), string.byte('z') do
        if vim.tbl_contains(marks_in_buffer, string.char(m)) ~= true then
            vim.api.nvim_buf_del_mark(0, string.char(m))
        end
    end

    for _, v in ipairs(items) do
        if v.type == nil or v.filename ~= vim.api.nvim_buf_get_name(0) then goto continue end

        if v.lnum == 0 or v.lnum > vim.fn.line('$') then goto continue end

        local mark = vim.api.nvim_buf_get_mark(0, v.type)
        if mark[1] == 0 and vim.tbl_contains(new_marks, v.type) ~= true then
            if string.match(v.text, "^<X> ") == nil then v.text = string.format("%s %s", "<X>", v.text) end
            goto continue
        end

        v.text = string.gsub(v.text, "^<X> ", "")
        vim.api.nvim_buf_set_mark(0, v.type, v.lnum, v.col, {})

        ::continue::
    end
end

local function load_qf_bookmark_keymap()
    vim.api.nvim_buf_set_keymap(0, 'n', 'dd', [[<cmd> lua require('features.bookmarks').Remove() <CR>]],
                                { silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<Tab>', [[<cmd> lua require('features.bookmarks').Review() <CR>]],
                                { silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', 'c', [[<cmd> lua require('features.bookmarks').Rename() <CR>]],
                                { silent = true })
end

local function get_same_path_bookmarks(filepath)
    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}
    local items = {}

    for _, v in ipairs(BookMarks) do if v.filename == filepath then table.insert(items, v) end end

    update_items_from_mark(items)

    table.sort(items, function(a, b) return a.lnum < b.lnum end)

    sort_items_by_mark(items)

    for _, v in ipairs(BookMarks) do if v.filename ~= filepath then table.insert(items, v) end end

    BookMarks = items
    require('features.files').SetJson(BookMarks, bookmarks_json_file)

    return items
end

local function save_bookmark()
    local filename = vim.fn.expand('%:p')

    if filename == '' then return {} end

    local bookmark = vim.fn.input('Enter bookmark: ')

    if bookmark == '' then return {} end

    if bookmark == ' ' then bookmark = vim.fn.getline('.') end

    local item = {}
    local content = vim.fn.getline('.')

    item.filename = filename
    item.text = bookmark
    item.lnum = vim.fn.line('.')
    item.col = vim.fn.col('.')
    item.bufnr = nil

    if vim.bo.filetype ~= 'qf' then item.content = content end

    local items, other_file_items = {}, {}
    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    for _, v in ipairs(BookMarks) do
        if v.filename == item.filename then
            local mark = { 0, 0 }

            if v.type ~= nil then mark = vim.api.nvim_buf_get_mark(0, v.type) end

            if mark[1] > 0 and mark[2] > 0 then v.lnum, v.col = mark[1], mark[2] end

            if (v.lnum ~= item.lnum) then table.insert(items, v) end
        else
            table.insert(other_file_items, v)
        end
    end

    table.insert(items, item)
    update_items_from_mark(items)
    sort_items_by_mark(items)

    for _, v in ipairs(other_file_items) do table.insert(items, v) end

    BookMarks = items
    require('features.files').SetJson(BookMarks, bookmarks_json_file)

    return BookMarks
end

local function load_local_bookmarks(row, col)
    local qf_title = vim.fn.getqflist({ title = 0 }).title

    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    if #BookMarks == 0 then
        if qf_title == bookmarks_qf_title then
            vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })

            if vim.bo.filetype == 'qf' then vim.cmd("silent! copen") end
        end

        return
    end

    local current_working_directory = vim.fn.getcwd()
    local items, other_wd_items = {}, {}

    for _, v in ipairs(BookMarks) do
        if string.match(v.filename, current_working_directory) then
            table.insert(items, v)
        else
            table.insert(other_wd_items, v)
        end
    end

    table.sort(items, function(a, b) return a.filename < b.filename end)

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
        table.sort(same_file_items, function(a, b) return a.lnum < b.lnum end)
        update_items_from_mark(same_file_items)
        sort_items_by_mark(same_file_items)
    end

    local action = ' '

    if qf_title == bookmarks_qf_title then action = 'r' end

    vim.fn.setqflist({}, action, {
        title = bookmarks_qf_title,
        items = same_file_items
    })
    vim.fn.setqflist({}, 'a', {
        title = bookmarks_qf_title,
        items = current_file_items
    })

    BookMarks = {}

    for _, v in ipairs(same_file_items) do table.insert(BookMarks, v) end

    for _, v in ipairs(current_file_items) do table.insert(BookMarks, v) end

    for _, v in ipairs(other_wd_items) do table.insert(BookMarks, v) end

    vim.cmd("silent! copen")

    load_qf_bookmark_keymap()

    if row ~= nil and col ~= nil then vim.fn.cursor(row, col) end

    require('features.files').SetJson(BookMarks, bookmarks_json_file)
end

local function load_bookmarks(row, col)
    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    local qf_title = vim.fn.getqflist({ title = 0 }).title
    local filename = vim.fn.expand('%:p')

    if #BookMarks == 0 then
        if qf_title == bookmarks_qf_title then
            vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })

            if vim.bo.filetype == 'qf' then vim.cmd("silent! copen") end
        end

        return
    end

    if vim.bo.filetype == 'qf' then
        if qf_title == bookmarks_qf_title then
            local qf_items = vim.fn.getqflist({
                title = bookmarks_qf_title,
                items = 0
            }).items
            row = row ~= nil and row or vim.fn.line('.')
            col = col ~= nil and col or vim.fn.col('.')

            if row <= #qf_items then filename = vim.api.nvim_buf_get_name(qf_items[row].bufnr) end
        end
    end

    table.sort(BookMarks, function(a, b) return a.filename < b.filename end)

    local same_file_items = {}
    local other_file_items = {}

    for _, v in ipairs(BookMarks) do
        if v.filename == filename then
            table.insert(same_file_items, v)
        else
            table.insert(other_file_items, v)
        end
    end

    if #same_file_items > 0 then
        table.sort(same_file_items, function(a, b) return a.lnum < b.lnum end)
        update_items_from_mark(same_file_items)
        sort_items_by_mark(same_file_items)
    end

    local action = ' '

    if qf_title == bookmarks_qf_title then action = 'r' end

    vim.fn.setqflist({}, action, {
        title = bookmarks_qf_title,
        items = same_file_items
    })
    vim.fn.setqflist({}, 'a', {
        title = bookmarks_qf_title,
        items = other_file_items
    })

    BookMarks = {}

    for _, v in ipairs(same_file_items) do table.insert(BookMarks, v) end

    for _, v in ipairs(other_file_items) do table.insert(BookMarks, v) end

    vim.cmd("silent! copen")

    load_qf_bookmark_keymap()

    if row ~= nil and col ~= nil then vim.fn.cursor(row, col) end

    require('features.files').SetJson(BookMarks, bookmarks_json_file)
end

local function rename_bookmark()
    local filename = vim.fn.expand('%:p')
    local lnum = vim.fn.line('.')
    local items

    if vim.bo.filetype == 'qf' then
        local qf_title = vim.fn.getqflist({ title = 0 }).title
        local qf_index = lnum

        if qf_title ~= bookmarks_qf_title then return end

        items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items
        filename = vim.api.nvim_buf_get_name(items[qf_index].bufnr)
        lnum = items[qf_index].lnum
    else
        local found_bookmark = false
        items = get_same_path_bookmarks(filename)

        if #items == 0 then return end

        for _, v in ipairs(items) do
            if v.lnum == lnum then
                found_bookmark = true
                break
            end
        end

        if found_bookmark == false then return end
    end

    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    if #BookMarks == 0 then return end

    for _, v in ipairs(BookMarks) do
        if v.lnum == lnum and v.filename == filename then
            local bookmark = vim.fn.input('Update bookmark: ', v.text)

            if bookmark ~= '' then
                v.text = bookmark
                require('features.files').SetJson(BookMarks, bookmarks_json_file)
            end

            break
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

    if vim.bo.filetype == 'qf' or filename == '' then return end

    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    for _, v in ipairs(BookMarks) do
        if v.lnum == current_line and v.filename == filename then
            remove_bookmark_content = v.text
            goto continue
        end

        table.insert(items, v)
        ::continue::
    end

    if remove_bookmark_content == nil then return end

    local prefix_string = string.format("[ X %s] ", bookmarks_qf_title)
    local display_string = string.format("%s%s", prefix_string, remove_bookmark_content)
    vim.api.nvim_echo({ { display_string } }, false, {})

    BookMarks = items
    require('features.files').SetJson(BookMarks, bookmarks_json_file)
end

local function remove_bookmark()
    if vim.bo.filetype ~= 'qf' then
        remove_bookmark_in_buffer()
        return
    else
        local qf_title = vim.fn.getqflist({ title = 0 }).title

        if qf_title ~= bookmarks_qf_title then return end
    end

    local items = {}
    local qf_items = vim.fn.getqflist({ title = bookmarks_qf_title, items = 0 }).items

    if #qf_items == 0 then
        vim.fn.setqflist({}, 'r', { title = bookmarks_qf_title, items = {} })
        return
    end

    local qf_index = vim.fn.line('.')
    local remove_item = qf_items[qf_index]
    local remove_filename

    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    for _, v in ipairs(BookMarks) do
        if v.lnum == remove_item.lnum then
            if remove_item.bufnr ~= nil then
                remove_filename = vim.api.nvim_buf_get_name(remove_item.bufnr)
            else
                remove_filename = remove_item.filename
            end

            if v.filename == remove_filename then goto continue end
        end

        table.insert(items, v)
        ::continue::
    end

    local row, col = vim.fn.line('.'), vim.fn.col('.')
    local is_local_bookmarks = #qf_items < #BookMarks
    BookMarks = items
    require('features.files').SetJson(BookMarks, bookmarks_json_file)

    row = row > 0 and row or 1
    col = col > 0 and col or 1

    if is_local_bookmarks == true then
        load_local_bookmarks(row, col)
    else
        load_bookmarks(row, col)
    end
end

local function clear_local_bookmarks()
    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    local current_working_directory = vim.fn.getcwd()
    local items = {}

    for _, v in ipairs(BookMarks) do
        if string.match(v.filename, current_working_directory) == nil then table.insert(items, v) end
    end

    BookMarks = items

    require('features.files').SetJson(BookMarks, bookmarks_json_file)
end

local function next_bookmark()
    local filename = vim.fn.expand('%:p')
    local items = get_same_path_bookmarks(filename)

    if #items == 0 then return end

    local current_line, last_line = vim.fn.line('.'), vim.fn.line('$')
    local next = { row = last_line, col = 0, msg = '' }
    local wrap = { row = current_line, col = 0, msg = '' }
    local current_line_msg = ''

    for _, v in ipairs(items) do
        if filename ~= v.filename then goto continue end

        if v.lnum > last_line then v.lnum = last_line end

        if v.lnum > current_line and v.lnum <= next.row then
            next.row = v.lnum
            next.col = v.col
            next.msg = v.text
        elseif v.lnum < current_line and v.lnum < wrap.row then
            wrap.row = v.lnum
            wrap.col = v.col
            wrap.msg = v.text
        elseif v.lnum == current_line then
            current_line_msg = v.text
        end

        ::continue::
    end

    local wrap_around = (next.row == last_line) and (next.col == 0) and (wrap.col > 0)
    local only_bookmark_at_current_line = (next.col == 0)

    if wrap_around == true then
        next.row, next.col = wrap.row, wrap.col
        next.msg = wrap.msg
    elseif only_bookmark_at_current_line == true then
        next.row, next.col = current_line, vim.fn.col('.')
        next.msg = current_line_msg
    end

    vim.fn.cursor(next.row, next.col)
    next.msg = string.format("[%s] %s", bookmarks_qf_title, next.msg)
    vim.api.nvim_echo({ { next.msg } }, false, {})
end

local function prev_bookmark()
    local filename = vim.fn.expand('%:p')
    local items = get_same_path_bookmarks(filename)

    if #items == 0 then return end

    local current_line, first_line = vim.fn.line('.'), 1
    local prev = { row = first_line, col = 0, msg = '' }
    local wrap = { row = current_line, col = 0, msg = '' }
    local current_line_msg = ''

    for _, v in ipairs(items) do
        if filename ~= v.filename then goto continue end

        if v.lnum < current_line and v.lnum >= prev.row then
            prev.row = v.lnum
            prev.col = v.col
            prev.msg = v.text
        elseif v.lnum > current_line and v.lnum > wrap.row then
            wrap.row = v.lnum
            wrap.col = v.col
            wrap.msg = v.text
        elseif v.lnum == current_line then
            current_line_msg = v.text
        end

        ::continue::
    end

    local wrap_around = (prev.row == first_line) and (prev.col == 0) and (wrap.col > 0)
    local only_bookmark_at_current_line = (prev.col == 0)

    if wrap_around == true then
        prev.row, prev.col = wrap.row, wrap.col
        prev.msg = wrap.msg
    elseif only_bookmark_at_current_line == true then
        prev.row, prev.col = current_line, vim.fn.col('.')
        prev.msg = current_line_msg
    end

    vim.fn.cursor(prev.row, prev.col)
    prev.msg = string.format("[%s] %s", bookmarks_qf_title, prev.msg)
    vim.api.nvim_echo({ { prev.msg } }, false, {})
end

local function review_bookmark_content()
    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}

    if #BookMarks == 0 then return end

    local filename
    local lnum

    if vim.bo.filetype == 'qf' then
        if vim.fn.getqflist({ title = 0 }).title ~= bookmarks_qf_title then return end

        local qf_items = vim.fn.getqflist({
            title = bookmarks_qf_title,
            items = 0
        }).items
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
    if vim.fn.isdirectory(bookmarks_dir) == 0 then vim.fn.mkdir(bookmarks_dir, 'p') end

    if vim.fn.filereadable(bookmarks_json_file) == 0 then vim.fn.writefile({}, bookmarks_json_file) end

    BookMarks = require('features.files').GetJson(bookmarks_json_file) or {}
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
