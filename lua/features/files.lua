local function get_dir()
    local current_file_dir = vim.fn.expand('%:p:h')
    vim.fn.setreg('+', tostring(current_file_dir))
    return current_file_dir
end

local function get_name()
    local current_file_name = vim.fn.expand('%:t')
    vim.fn.setreg('+', tostring(current_file_name))
    return current_file_name
end

local function get_full_path()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', tostring(path))
    return path
end

local function get_path()
    local path = vim.fn.expand('%')
    vim.fn.setreg('+', tostring(path))
    return path
end

local function get_files(path)
    local uv = vim.loop
    local files = {}
    local handle = uv.fs_scandir(path)

    if handle then
        while true do
            local name, type = uv.fs_scandir_next(handle)

            if not name then
                break
            end

            if type == "file" then
                table.insert(files, name)
            end
        end
    end

    return files
end

local function recursive_file_search(dir, file_pattern)
    local uv = vim.loop

    if dir == nil or vim.fn.len(dir) == 0 then
        dir = uv.cwd()
    end

    if file_pattern == nil then
        file_pattern = "*"
    end

    local cmd = "find " .. dir .. " -type f -name " .. '"' .. file_pattern .. '"' .. " -print"
    local result = vim.fn.system(vim.fn.expand(cmd))
    local files = vim.split(result, "\n")
    table.remove(files, #files)
    return files
end

local function check_extension_file_exist(extension)
    if extension == nil then
        extension = vim.fn.expand("%:e")
    end

    local cmd = "find . -type f -name " .. '"*.' .. extension .. '"' .. " -print -quit | wc -l"
    local result = tonumber(vim.fn.system(cmd))

    return result
end

local function search_file()
    local regex_file = vim.fn.input("File to search (regex): ")

    if regex_file == "" or regex_file == nil then
        return
    end

    local files = recursive_file_search(vim.loop.cwd(), regex_file)
    local msg = string.format("\tfound %d files", #files)

    if #files == 0 or files == nil then
        vim.api.nvim_echo({ { "\tfiles not found", "" } }, false, {})
        return
    end

    local items = {}
    local std_item = { filename = nil, text = nil, type = 'f', bufnr = nil }

    for _, file in ipairs(files) do
        local item = vim.deepcopy(std_item)
        item.filename = file
        item.text = string.format("[%s]", vim.fn.fnamemodify(file, ':t'))
        table.insert(items, item)
    end

    vim.fn.setqflist({}, ' ', { title = "Find Files", items = items })
    vim.api.nvim_echo({ { msg, "MoreMsg" } }, false, {})
    vim.cmd("silent! copen")
end

local function json_write(tbl, path)
    if tbl == nil then
        vim.api.nvim_echo({ { "empty table ...", "ErrorMsg" } }, false, {})
        return false
    end

    if path == nil or #path == 0 then
        vim.api.nvim_echo({ { "file path is empty ...", "ErrorMsg" } }, false, {})
        return false
    end

    local json_format = vim.json.encode(tbl)
    local file = io.open(path, "w")

    if file == nil then
        vim.api.nvim_echo({ { "file open failed ...", "ErrorMsg" } }, false, {})
        return false
    end

    file:write(json_format)
    file:close()

    return true
end

local function json_read(path)
    if path == nil then
        vim.api.nvim_echo({ { "file path is empty ...", "ErrorMsg" } }, false, {})
        return {}
    end

    local file = io.open(path, "r")

    if file == nil then
        vim.api.nvim_echo({ { "file open failed ...", "ErrorMsg" } }, false, {})
        return nil
    end

    local json_format = file:read("*a")
    file:close()

    if #json_format == 0 then
        return {}
    end

    return vim.json.decode(json_format)
end

-- @name: save_command_message_to_file
-- @description: save command message to file
-- @param cmd: string
-- @return: nil
-- @usage: save_command_message_to_file(":messages")
-- @usage: save_command_message_to_file("!git log")
local function save_command_message_to_file(cmd)
    if cmd == nil or #cmd == 0 then
        cmd = ":messages"
    end

    local file = vim.fn.tempname()
    local commands = { "redir! > " .. file, cmd, "redir END", "view " .. file }

    for _, c in ipairs(commands) do
        vim.cmd(c)
    end
end

local function setup()
    local skip_functions = { '^Setup$', '^.*Json$' }

    for name in pairs(require('features.files')) do
        for _, skip in ipairs(skip_functions) do
            if name:match(skip) ~= nil then
                goto continue
            end
        end

        local callback = "require('features.files')." .. name .. "()"
        vim.cmd("command! -nargs=0 -bang " .. "File" .. name .. " lua print(" .. callback .. ")")
        ::continue::
    end

    vim.cmd("command! -nargs=1 -bang FileSaveCmdMsgInput lua require('features.files').SaveCmdMsg(<f-args>)")
end

return {
    GetDir = get_dir,
    GetName = get_name,
    GetPath = get_path,
    GetFullPath = get_full_path,
    GetAll = get_files,
    ChkExtExist = check_extension_file_exist,
    RecurSearch = recursive_file_search,
    Search = search_file,
    SetJson = json_write,
    GetJson = json_read,
    SaveCmdMsg = save_command_message_to_file,
    Setup = setup
}
