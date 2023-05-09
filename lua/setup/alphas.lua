local if_nil = vim.F.if_nil

local default_terminal = {
    type = "terminal",
    command = nil,
    width = 69,
    height = 8,
    opts = {
        redraw = true,
        window_config = {},
    },
}

local default_header = {
    type = "text",
    val = {
[[     ███████╗  ███╗   ███╗ ██╗            ███████╗  ██████╗]],
[[     ╚═════██╗ ████╗ ████║ ██║            ██╔════╝ ██╔════╝]],
[[     ████████║ ██╔████╔██║ ██║ █████████╗ █████╗   ██║]],
[[     ██║   ██║ ██║╚██╔╝██║ ██║ ╚════════╝ ██╔══╝   ██║]],
[[     ╚██████╔╝ ██║ ╚═╝ ██║ ██║            ███████╗ ╚██████╗]],
[[      ╚═════╝  ╚═╝     ╚═╝ ╚═╝            ╚══════╝  ╚═════╝]],
[[                             ██═╗   ██╗]],
[[                              ██╚╗██╔═╝]],
[[                               ████╔╝]],
[[                              ██╔═██═╗]],
[[                             ██╔╝  ╚██╗]],
[[                             ╚═╝    ╚═╝]],
[[ ███████╗  ██╗  ██████╗ ██╗     ██╗  ██████╗  ███████╗  ███████╗]],
[[ ██╔═══██╗ ██║ ██╔════╝ ██║     ██║ ██╔═══██╗ ██╔═══██╗ ██╔═══██╗]],
[[ ████████║ ██║ ██║      ██████████║ ████████║ ████████║ ██║   ██║]],
[[ ██╔═██╔═╝ ██║ ██║      ██╔═════██║ ██╔═══██║ ██╔═██╔═╝ ██║   ██║]],
[[ ██║ ████╗ ██║ ╚██████╗ ██║     ██║ ██║   ██║ ██║ ████╗ ███████╔╝]],
[[ ╚═╝ ╚═══╝ ╚═╝  ╚═════╝ ╚═╝     ╚═╝ ╚═╝   ╚═╝ ╚═╝ ╚═══╝ ╚══════╝]],
    },
    opts = {
        position = "center",
        hl = "String",
        -- wrap = "overflow";
    },
}

local footer = {
    type = "text",
    val = "",
    opts = {
        position = "center",
        hl = "Number",
    },
}

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
    }
    if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "tx", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

local buttons = {
    type = "group",
    val = {
        button("`", "  Configuration", "<cmd>e $MYVIMRC<CR>"),
        button("1", "  Recently opened files", "<cmd> lua require('telescope.builtin').oldfiles()<CR>"),
        button("2", "  Open last session", "<cmd> SessionManager load_last_session<CR>"),
        button("3", "  Load current directory session", "<cmd> SessionManager load_current_dir_session<CR>"),
        button("4", "  Find file", "<cmd> lua require('telescope.builtin').find_files()<CR>"),
        button("5", "  Find word",  "<cmd> lua require('telescope.builtin').live_grep({prompt_title='search all', glob_pattern=ignore_type([[!.*]])}) <CR>"),
        button("6", "  Jump to bookmarks", "<cmd> lua require('telescope.builtin').marks() <CR>"),
        button("7", "  Frecency/MRU", "<cmd> lua require('telescope.builtin').jumplist()<CR>"),
        button("8", "  Git Status",  "<cmd>lua require('telescope.builtin').git_status()<CR>"),
        button("9", "  Git logs", "<cmd>lua require('telescope.builtin').git_status()<CR>"),
        button("1 0", "  Create ctags", "<cmd> !ctags -R --verbose=yes .<CR>"),
        button("1 1", "  Create cscope", "<cmd> !cscope -bqRv <CR>"),
        button("SPC t S", "  View process system"),
    },
    opts = {
        spacing = 1,
    },
}

local section = {
    terminal = default_terminal,
    header = default_header,
    buttons = buttons,
    footer = footer,
}

local config = {
    layout = {
        { type = "padding", val = 2 },
        section.header,
        { type = "padding", val = 2 },
        section.buttons,
        section.footer,
    },
    opts = {
        margin = 5,
    },
}

return {
    button = button,
    section = section,
    config = config,
    -- theme config
    leader = leader,
    -- deprecated
    opts = config,
}
