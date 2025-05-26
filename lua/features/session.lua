local d = vim.fn.has("win32") ~= 0 and "\\" or "/"
local path = vim.fn.stdpath("data") .. d .. "sessions"
local session_name = vim.fn.substitute(
    vim.fn.expand(vim.fn.getcwd()),
    d,
    "_",
    "g"
) .. ".vim"
local src = path .. d .. session_name
local json_file = path .. d .. "sessions.json"
local working_directory_json_file = path .. d .. "working_directory.json"
local uv = vim.loop
local work_dirs = { uv.cwd() }

local function get_session_tbl()
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end

    if vim.fn.filereadable(json_file) == 0 then
        vim.fn.writefile({}, json_file)
    end

    return require("features.files").GetJson(json_file) or {}
end

local function save_session()
    local format = {
        path = vim.fn.getcwd(),
        src = src,
        name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
        date = os.date("%Y/%h/%d"),
    }

    vim.fn.sessionoptions = {
        "buffers",
        "curdir",
        "folds",
        "tabpages",
        "winsize",
    }

    vim.cmd("mksession! " .. src)
    local json_lua_tbl = get_session_tbl()

    for i, v in ipairs(json_lua_tbl) do
        if v.path == format.path then
            table.remove(json_lua_tbl, i)
            break
        end
    end

    table.insert(json_lua_tbl, format)
    require("features.files").SetJson(json_lua_tbl, json_file)
end

local function load_session()
    if (vim.fn.isdirectory(path) == 1) and (vim.fn.filereadable(src) == 1) then
        vim.cmd("source " .. src)
    else
        vim.api.nvim_echo({ { "Session not found !", "ErrorMsg" } }, false, {})
    end
end

local function select_session()
    local lists = {}
    local json_lua_tbl = get_session_tbl()

    for i, v in ipairs(json_lua_tbl) do
        lists[i] =
            string.format("%2d. [%s]:\t%s\t{%s}", i, v.name, v.path, v.date)
    end

    if #lists == 0 then
        vim.api.nvim_echo({ { "Session not found !", "ErrorMsg" } }, false, {})
        return
    end

    require("features.common").DisplayTitle("Select Session to Load")
    local s = vim.fn.inputlist(lists)

    if s > 0 then
        vim.cmd("source " .. json_lua_tbl[s].src)
    end
end

local function change_and_save_working_directory()
    local current_file_dir = vim.fn.expand("%:p:h")

    vim.api.nvim_echo({ { "change working directory to: ", "None" } }, true, {})
    vim.api.nvim_echo({ { current_file_dir, "WarningMsg" } }, true, {})
    save_session()
    vim.cmd("cd " .. current_file_dir)

    for i, v in ipairs(work_dirs) do
        if v == current_file_dir then
            table.remove(work_dirs, i)
        end
    end

    table.insert(work_dirs, current_file_dir)
    require("features.files").SetJson(work_dirs, working_directory_json_file)
end

local function save_current_working_directory()
    local current_file_dir = uv.cwd()

    vim.api.nvim_echo({ { "save working directory: ", "None" } }, true, {})
    vim.api.nvim_echo({ { current_file_dir, "WarningMsg" } }, true, {})
    save_session()

    for i, v in ipairs(work_dirs) do
        if v == current_file_dir then
            table.remove(work_dirs, i)
        end
    end

    table.insert(work_dirs, current_file_dir)
    require("features.files").SetJson(work_dirs, working_directory_json_file)
end

local function select_working_directory()
    local lists = {}

    for i, v in ipairs(work_dirs) do
        lists[i] = string.format("%2d: %s", i, v)
    end

    local chg_work_dir = require("features.common").TableSelection(
        work_dirs,
        lists,
        "Change Working Directory"
    )

    if chg_work_dir == nil then
        return
    end

    save_session()
    vim.cmd("cd " .. chg_work_dir)
end

local function clear_working_directory_history()
    work_dirs = { uv.cwd() }
end

local function delete_working_directory_history()
    local lists = {}

    for i, v in ipairs(work_dirs) do
        lists[i] = string.format("%2d: %s", i, v)
    end

    local chg_work_dir = require("features.common").TableSelection(
        work_dirs,
        lists,
        "Remove Working Directory"
    )

    if chg_work_dir == nil then
        return
    end

    for i, v in ipairs(work_dirs) do
        if v == chg_work_dir then
            table.remove(work_dirs, i)
            break
        end
    end

    require("features.files").SetJson(work_dirs, working_directory_json_file)
end

local function setup()
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end

    if vim.fn.filereadable(working_directory_json_file) == 0 then
        vim.fn.writefile({}, working_directory_json_file)
    end

    work_dirs = require("features.files").GetJson(working_directory_json_file)
        or { uv.cwd() }
end

return {
    Save = save_session,
    Get = load_session,
    Select = select_session,
    ChgSaveWD = change_and_save_working_directory,
    SaveWD = save_current_working_directory,
    SelWD = select_working_directory,
    ClrWD = clear_working_directory_history,
    DelWD = delete_working_directory_history,
    Setup = setup,
}
