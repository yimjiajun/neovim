local function search_word(extension, mode)
    local word, cmd

    if extension == nil then extension = vim.fn.input("Enter filetype to search: ", vim.fn.expand("%:e")) end

    if extension == "" then extension = "*" end

    if mode ~= 'cursor' then
        word = vim.fn.input("Enter word to search: ")
    else
        word = vim.fn.expand("<cword>")
    end

    if word == "" then return end

    vim.fn.setreg('/', tostring(word))

    if vim.fn.executable("rg") == 1 then
        if extension == "*" then
            extension = [[--glob "*"]]
        else
            extension = string.format([[--glob "*.%s"]], extension)
        end

        local opts = " --no-ignore "

        if mode == 'complete' then
            opts = opts .. " --case-sensitive "
        else
            opts = opts .. " --smart-case "
        end

        vim.fn.setreg('e', extension)
        vim.fn.setreg('o', opts)
        cmd = [[cgetexpr system('rg --vimgrep ' .. getreg('o') .. " --regexp " .. getreg('/') .. " " .. getreg('e'))]]
    else
        if extension ~= "*" then extension = [[*.]] .. extension end

        vim.fn.setreg('e', tostring(extension))
        cmd = [[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj ./**/]] .. vim.fn.getreg('e')
    end

    vim.cmd("silent! " .. cmd .. " | silent! +copen 5")
    vim.fn.setqflist({}, 'r', { title = "search word: " .. vim.fn.getreg('/') })
end

local function search_word_by_file(file, mode)
    local word, cmd

    if file == nil or file == "" then search_word("*", "normal") end

    if mode ~= 'cursor' then
        word = vim.fn.input("Enter word to search: ")
    else
        word = vim.fn.expand("<cword>")
    end

    if word == "" then return end

    vim.fn.setreg('/', tostring(word))

    if vim.fn.executable("rg") == 1 then
        file = string.format("{%s,./**/%s}", file, file)
        local opts = " --no-ignore "

        if mode == 'complete' then
            opts = opts .. " --case-sensitive "
        else
            opts = opts .. " --smart-case "
        end

        vim.fn.setreg('e', file)
        vim.fn.setreg('o', opts)
        cmd = [[cgetexpr system('rg --vimgrep ' .. getreg('o') .. " --regexp " .. getreg('/') .. " " .. getreg('e'))]]
    else
        vim.fn.setreg('e', tostring(file))
        cmd = [[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj ./**/]] .. vim.fn.getreg('e')
    end

    vim.cmd("silent! " .. cmd .. " | silent! +copen 5")
    vim.fn.setqflist({}, 'r', {
        title = "search word in file: " .. vim.fn.getreg('/')
    })
end

local function search_word_by_buffer()
    vim.fn.setreg('/', vim.fn.expand("<cword>"))
    vim.cmd([[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj %]])
    vim.fn.setqflist({}, 'r', { title = "search buffer: " .. vim.fn.getreg('/') })
    vim.cmd("silent! +copen 5")
end

-- @brief Toggle comment (deprecated after 0.10.0, neovim has built-in support)
-- @description Toggle comment in current line or selected lines
-- @usage ToggleComment()
local function toggle_comment()
    local tbl = {}
    local comments_tbl = {
        { type = 'c', prefix = '//' }, { type = 'lua', prefix = '--' },
        { type = 'python', prefix = "\\#" }, { type = 'sh', prefix = "\\#" }
    }

    local function toggle(prefix, lnum, opts)
        local ltext = vim.fn.getline(lnum)
        local prefix_char_count = vim.fn.strchars(prefix)
        local prefix_char_wrapper = ""
        local trigger, idx, substitue_info

        idx = 1
        while idx <= prefix_char_count do
            prefix_char_wrapper = prefix_char_wrapper .. "[" .. vim.fn.strcharpart(prefix, idx - 1, 1) .. "]"
            idx = idx + 1
        end
        -- remove escape character. ex \# -> #
        prefix_char_wrapper = string.gsub(prefix_char_wrapper, "[\\[\\]\\]", "")

        substitue_info = {
            {
                pattern = '^' .. prefix_char_wrapper .. ' .*$',
                substitue = 's#' .. prefix .. ' ##'
            }, {
                pattern = '^' .. prefix_char_wrapper .. '.*$',
                substitue = 's#' .. prefix .. '##'
            }
        }

        trigger = true

        for _, v in ipairs(substitue_info) do
            if string.match(vim.fn.trim(ltext), v.pattern) then
                vim.cmd(lnum .. v.substitue)
                trigger = false
                break
            end
        end

        if opts ~= nil and opts.trigger ~= nil then trigger = opts.trigger end

        if trigger == true and string.match(ltext, '^$') == nil then
            vim.cmd(lnum .. 's#\\S#' .. vim.fn.trim(prefix) .. ' &#')
        end
    end

    for _, v in ipairs(comments_tbl) do
        if v.type == vim.bo.filetype then
            tbl = v
            break
        end
    end

    if vim.fn.len(tbl) == 0 then return end

    local hold_search_reg = vim.fn.getreg('/')

    if vim.fn.mode() == 'V' then
        local lbegin = vim.fn.line("'<")
        local lend = vim.fn.line("'>")
        local trigger_comment = vim.fn.search(tbl.prefix, 'cn', lend) == 0

        while lbegin <= lend do
            toggle(tbl.prefix, lbegin, { trigger = trigger_comment })
            lbegin = lbegin + 1
        end
    elseif vim.fn.mode() == 'n' then
        toggle(tbl.prefix, vim.fn.line('.'))
    end

    vim.fn.setreg('/', hold_search_reg)
end

local function setup() end

return {
    Search = search_word,
    SearchByFile = search_word_by_file,
    SearchByBuffer = search_word_by_buffer,
    ToggleComment = toggle_comment,
    Setup = setup
}
