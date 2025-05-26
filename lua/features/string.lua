local search_options = {
    smart_case = false,
    case_sensitive = false,
    ignore_case = false,
}

-- @brief Setup search options
-- @description Update search options, if the options are not provided,
--              the default options will be used and overwritten in search search_pattern_async
-- @param opts Search options
local function setup_search_options(opts)
    local value = {}
    local s = search_options
    local selection = {
        ["Smart Case"] = string.format("Smart Case: %s", s.smart_case),
        ["Case Sensitive"] = string.format(
            "Case Sensitive: %s",
            s.case_sensitive
        ),
        ["Ignore Case Sensitive"] = string.format(
            "Ignore Case Sensitive: %s",
            s.ignore_case
        ),
    }

    for _, v in pairs(selection) do
        table.insert(value, v)
    end

    table.sort(value, function(a, b)
        return a < b
    end)

    if opts == nil then
        -- spawn table to
        vim.ui.select(value, { prompt = "Search Options" }, function(choice)
            if choice == selection["Smart Case"] then
                search_options.smart_case = not s.smart_case
            elseif choice == selection["Case Sensitive"] then
                search_options.case_sensitive = not s.case_sensitive
            elseif choice == selection["Ignore Case Sensitive"] then
                search_options.ignore_case = not s.ignore_case
            end
        end)
    else
        opts = (opts == nil) and {} or opts
        search_options = {
            smart_case = (opts.smart_case == nil) and s.smart_case
                or opts.smart_case,
            case_sensitive = (opts.case_sensitive == nil) and s.case_sensitive
                or opts.case_sensitive,
            ignore_case = (opts.ignore_case == nil) and s.ignore_case
                or opts.ignore_case,
        }
    end

    return search_options
end

-- @brief Search pattern asynchronously
-- @param key Search key
-- @param opts Search options
local function search_pattern_async(key, opts)
    opts = (opts == nil) and {} or opts
    opts = {
        smart_case = (opts.smart_case == nil) and search_options.smart_case
            or opts.smart_case,
        case_sensitive = (opts.case_sensitive == nil)
                and search_options.case_sensitive
            or opts.case_sensitive,
        ignore_case = (opts.ignore_case == nil) and search_options.ignore_case
            or opts.ignore_case,
        extension = (opts.extension == nil) and "*" or opts.extension,
        extension_is_regexp_path = (opts.extension_is_regexp_path == nil)
                and false
            or opts.extension_is_regexp_path,
        vimgrep = (opts.vimgrep == nil) and false or opts.vimgrep,
    }
    local extension = (opts.extension == "")
            and vim.fn.input(
                "Enter file extension: ",
                string.format("*.%s", vim.fn.expand("%:e"))
            )
        or opts.extension
    local options = string.format(
        "%s %s %s",
        (opts.smart_case == nil or opts.smart_case == false) and ""
            or "--smart-case",
        (opts.case_sensitive == nil or opts.case_sensitive == false) and ""
            or "--case-sensitive",
        (opts.ignore_case == nil or opts.ignore_case == false) and ""
            or "--ignore-case"
    )
    local stdout = vim.loop.new_pipe(false) -- Create a new pipe for stdout
    local stderr = vim.loop.new_pipe(false) -- Create a new pipe for stderr
    local handle -- Store the process handle
    local timeout = 10000 -- Define timeout in milliseconds
    local temp_file = vim.fn.tempname() -- Read the output to a temporary file and open it in quickfix window

    if key == nil then
        vim.ui.input({ prompt = "Enter pattern for search: " }, function(input)
            key = input
        end)
    end

    if key == nil then
        return
    end

    key = (key == "") and vim.fn.expand("<cword>") or key
    -- Set the search key, extension and options in the register
    vim.fn.setreg("/", tostring(key))
    vim.fn.setreg("e", tostring(extension))
    vim.fn.setreg("o", tostring(options))

    if vim.fn.executable("rg") == 0 or opts.vimgrep == true then
        local cmd = string.format(
            "silent! vimgrep /%s/gj ./**/%s",
            vim.fn.getreg("/"),
            vim.fn.getreg("e")
        )
        vim.cmd(string.format("silent! %s | silent! +copen 5", cmd))
        vim.fn.setqflist({}, "r", {
            title = string.format("Vim Search >> %s", vim.fn.getreg("/")),
        })

        return
    end

    local cmd = "rg"
    local cmd_args

    if opts.extension_is_regexp_path == true then
        cmd_args = vim.split(
            string.format(
                "--vimgrep --no-ignore %s --regexp %s %s",
                options,
                key,
                extension
            ),
            "%s+"
        )
    elseif extension == "*" then
        cmd_args = vim.split(
            string.format("--vimgrep --no-ignore %s --regexp %s", options, key),
            "%s+"
        )
    else
        cmd_args = vim.split(
            string.format(
                "--vimgrep --no-ignore %s --regexp %s --glob %s",
                options,
                key,
                extension
            ),
            "%s+"
        )
    end

    -- @brief Callback function to handle the exit of the process
    -- @param _ Exit code (0 for success, non-zero for failure)
    -- @param _ Signal number (0 for success, non-zero for failure)
    local function on_exit(_, _)
        if vim.fn.filereadable(temp_file) == 0 then
            vim.api.nvim_err_writeln(
                string.format("'%s' pattern NOT found", key)
            )
        else
            vim.cmd(string.format("cgetfile %s", temp_file))
            vim.cmd("silent! cwindow")
        end

        if stdout and not stdout:is_closing() then
            stdout:close()
        end

        if stderr and not stderr:is_closing() then
            stderr:close()
        end

        if handle and not handle:is_closing() then
            handle:close()
        end
    end

    handle = vim.loop.spawn(cmd, {
        args = cmd_args,
        stdio = { nil, stdout, stderr },
    }, vim.schedule_wrap(on_exit))

    if not handle then
        vim.api.nvim_err_writeln(
            string.format("Failed to start process to search: %s", key)
        )
        return
    end

    vim.api.nvim_echo(
        { { string.format("\tSearching >> '%s'", key), "MoreMsg" } },
        false,
        {}
    )

    -- @brief Read the output from the process
    -- @param err Error message
    -- @param data Output data
    local function on_read(err, data)
        assert(not err, err)

        if data then
            local file = io.open(temp_file, "a")
            file:write(data)
            file:close()
        end
    end

    stdout:read_start(on_read)
    stderr:read_start(on_read)

    vim.defer_fn(function()
        if stdout and not stdout:is_closing() then
            stdout:close()
        end

        if stderr and not stderr:is_closing() then
            stderr:close()
        end

        if handle and not handle:is_closing() then
            handle:kill("sigterm")
            handle:close()
        end
    end, timeout)
end

-- @brief Search word by buffer
-- @description Search word under cursor in the current buffer and display the result in quickfix window
local function search_word_by_buffer()
    vim.fn.setreg("/", vim.fn.expand("<cword>"))
    vim.cmd([[silent! vimgrep /]] .. vim.fn.getreg("/") .. [[/gj %]])
    vim.fn.setqflist(
        {},
        "r",
        { title = "search buffer: " .. vim.fn.getreg("/") }
    )
    vim.cmd("silent! +copen 5")
end

-- @brief Toggle comment (deprecated after 0.10.0, neovim has built-in support)
-- @description Toggle comment in current line or selected lines
-- @usage ToggleComment()
local function toggle_comment()
    local tbl = {}
    local comments_tbl = {
        { type = "c", prefix = "//" },
        { type = "lua", prefix = "--" },
        { type = "python", prefix = "\\#" },
        { type = "sh", prefix = "\\#" },
    }

    local function toggle(prefix, lnum, opts)
        local ltext = vim.fn.getline(lnum)
        local prefix_char_count = vim.fn.strchars(prefix)
        local prefix_char_wrapper = ""
        local trigger, idx, substitue_info

        idx = 1
        while idx <= prefix_char_count do
            prefix_char_wrapper = prefix_char_wrapper
                .. "["
                .. vim.fn.strcharpart(prefix, idx - 1, 1)
                .. "]"
            idx = idx + 1
        end
        -- remove escape character. ex \# -> #
        prefix_char_wrapper = string.gsub(prefix_char_wrapper, "[\\[\\]\\]", "")

        substitue_info = {
            {
                pattern = "^" .. prefix_char_wrapper .. " .*$",
                substitue = "s#" .. prefix .. " ##",
            },
            {
                pattern = "^" .. prefix_char_wrapper .. ".*$",
                substitue = "s#" .. prefix .. "##",
            },
        }

        trigger = true

        for _, v in ipairs(substitue_info) do
            if string.match(vim.fn.trim(ltext), v.pattern) then
                vim.cmd(lnum .. v.substitue)
                trigger = false
                break
            end
        end

        if opts ~= nil and opts.trigger ~= nil then
            trigger = opts.trigger
        end

        if trigger == true and string.match(ltext, "^$") == nil then
            vim.cmd(lnum .. "s#\\S#" .. vim.fn.trim(prefix) .. " &#")
        end
    end

    for _, v in ipairs(comments_tbl) do
        if v.type == vim.bo.filetype then
            tbl = v
            break
        end
    end

    if vim.fn.len(tbl) == 0 then
        return
    end

    local hold_search_reg = vim.fn.getreg("/")

    if vim.fn.mode() == "V" then
        local lbegin = vim.fn.line("'<")
        local lend = vim.fn.line("'>")
        local trigger_comment = vim.fn.search(tbl.prefix, "cn", lend) == 0

        while lbegin <= lend do
            toggle(tbl.prefix, lbegin, { trigger = trigger_comment })
            lbegin = lbegin + 1
        end
    elseif vim.fn.mode() == "n" then
        toggle(tbl.prefix, vim.fn.line("."))
    end

    vim.fn.setreg("/", hold_search_reg)
end

-- @brief Setup
-- @description Setup the features for string.lua
local function setup() end

return {
    Search = search_pattern_async,
    SetupSearchOptions = setup_search_options,
    SearchByBuffer = search_word_by_buffer,
    ToggleComment = toggle_comment,
    Setup = setup,
}
