local function setup()
    require("which-key").setup({
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20 -- how many suggestions should be shown in the list?
            },
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = true, -- adds help for operators like d, y,
                -- ... and registers them for motion / text object completion
                motions = true, -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true -- bindings for prefixed with g
            }
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "|", -- symbol used between a key and it's label
            group = "+ ", -- symbol prepended to a group
            colors = false,
            mappings = false -- set to false to disable all mapping icons,
        },
        layout = {
            height = { min = 4, max = 20 }, -- min and max height of the columns
            width = { min = 10, max = 40 }, -- min and max width of the columns
            spacing = 10, -- spacing between columns
            align = "center" -- align columns left, center or right
        },
        keys = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>" -- binding to scroll up inside the popup
        },
        replace = {
            key = {
                function(key)
                    return require("which-key.view").format(key)
                end
                -- { "<Space>", "SPC" },
            },
            desc = {
                { "<Plug>%(?(.*)%)?", "%1" }, { "^%+", "" }, { "<[cC]md>", "" },
                { "<[cC][rR]>", "" }, { "<[sS]ilent>", "" }, { "^lua%s+", "" },
                { "^call%s+", "" }, { "^:%s*", "" }
            }
        },
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = { { "<leader>", mode = "nv" } },
        -- triggers = {"<leader>"}, -- or specify a list manually
        win = {
            -- don't allow the popup to overlap with the cursor
            no_overlap = true,
            -- width = 1,
            -- height = { min = 4, max = 25 },
            -- col = 0,
            -- row = math.huge,
            border = "single", -- none, single, double, shadow
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
            title = false,
            title_pos = "center",
            zindex = 1000,
            -- Additional vim.wo and vim.bo options
            bo = {},
            wo = {
                -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
            }
        }
    })

    local wk = require("which-key")
    wk.add({
        { "<leader><BS>", desc = 'kill Buffers' },
        { "<leader>w", desc = 'buffer' }, { "<leader>q", desc = 'marks' },
        { "<leader>h", desc = 'jumplist' }, { "<leader>r", desc = 'registers' },
        { "<leader>e", desc = 'explorer' },
        { "<leader>E", desc = 'explorer File' },
        { "<leader>b", desc = 'build' }, { "<leader>B", desc = 'build latest' },
        { "<leader>c", desc = 'quickfix' }, { "<leader>d", desc = 'Debugger' },
        { "<leader>B", desc = "build latest" },
        { "<leader>B", desc = "build latest" },
        { "<leader>E", desc = "explorer File" },
        { "<leader>S", group = "Unload" },
        { "<leader>SB", desc = "bookmarks (cwd)" },
        { "<leader>SM", desc = "mark (local)" },
        { "<leader>SU", desc = "mark (universal)" },
        { "<leader>Sb", desc = "bookmarks" },
        { "<leader>Sm", desc = "mark (buffer)" },
        { "<leader>Su", desc = "mark (buffers)" },
        { "<leader>b", desc = "build" }, { "<leader>c", desc = "quickfix" },
        { "<leader>d", desc = "Debugger" }, { "<leader>e", desc = "explorer" },
        { "<leader>f", group = "Find" },
        { "<leader>fA", desc = "all (usr input)" },
        { "<leader>fC", desc = "c, cpp, h" },
        { "<leader>fK", desc = "Kconfig" },
        { "<leader>fV", desc = "Vimgrep - complete word" },
        { "<leader>fa", desc = "all" }, { "<leader>fc", desc = "c" },
        { "<leader>fD", desc = "dts{i}" }, { "<leader>ff", desc = "file" },
        { "<leader>fh", desc = "h" }, { "<leader>fk", desc = "conf" },
        { "<leader>fm", desc = "CMakeLists" },
        { "<leader>fq", desc = "customize search word" },
        { "<leader>fs", desc = "setup search (legacy)" },
        { "<leader>fv", desc = "Vimgrep" }, { "<leader>fw", desc = "word" },
        { "<leader>fd", desc = "Backward directory search" },
        { "<leader>g", group = "Global Plug" }, { "<leader>gg", group = "Git" },
        { "<leader>ggA", desc = "add all" },
        { "<leader>ggC", desc = "commit count" },
        { "<leader>ggD", desc = "diff previous" },
        { "<leader>ggH", desc = "log patch" }, { "<leader>ggL", desc = "log" },
        { "<leader>ggS", desc = "status short" },
        { "<leader>gga", desc = "add" }, { "<leader>ggc", desc = "commit" },
        { "<leader>ggd", desc = "diff" },
        { "<leader>ggh", desc = "diff staging" },
        { "<leader>ggl", desc = "log Graph" },
        { "<leader>ggp", desc = "add patch" },
        { "<leader>ggs", desc = "status" },
        { "<leader>ggw", desc = "white space check" },
        { "<leader>h", desc = "jumplist" }, { "<leader>o", group = "Open" },
        { "<leader>oB", desc = "bookmarks (all)" },
        { "<leader>oM", desc = "mark (local)" },
        { "<leader>oS", desc = "session (selection)" },
        { "<leader>oU", desc = "mark (universal)" },
        { "<leader>ob", desc = "bookmarks" },
        { "<leader>om", desc = "mark (buffer)" },
        { "<leader>os", desc = "session" },
        { "<leader>ot", desc = "todo lists" },
        { "<leader>ou", desc = "mark (sort buffer)" },
        { "<leader>q", desc = "marks" }, { "<leader>r", desc = "registers" },
        { "<leader>s", group = "Save" },
        { "<leader>sB", desc = "bookmarks (rename)" },
        { "<leader>sM", desc = "mark (local)" },
        { "<leader>sb", desc = "bookmarks" },
        { "<leader>sm", desc = "mark (buffer)" },
        { "<leader>st", desc = "todo lists" },
        { "<leader>t", group = "Toggle" }, { "<leader>tF", desc = "scp send" },
        { "<leader>tS", desc = "+ Secure Shell Protocol" },
        { "<leader>tc", desc = "ctags generator" },
        { "<leader>te", desc = "file format" },
        { "<leader>tf", desc = "terminal" },
        { "<leader>ts", desc = "terminal split" },
        { "<leader>tv", desc = "terminal vsplit" },
        { "<leader>tw", group = "working directory" },
        { "<leader>twc", desc = "clear saved path" },
        { "<leader>twr", desc = "restore from saved path" },
        { "<leader>tws", desc = "save current path" },
        { "<leader>tww", desc = "chg & save current path" },
        { "<leader>v", group = "View" }, { "<leader>vc", group = "Calendar" },
        { "<leader>vci", desc = "interactive" },
        { "<leader>vs", group = "System" }, { "<leader>vsb", desc = "battery" },
        { "<leader>w", desc = "buffer" }
    }, { mode = "n" })
    wk.add({ mode = { "v" }, { "<leader>g", group = "Global Plug" } })
    vim.cmd("highlight default link WhichKeyFloat Normal")
end

return { Setup = setup }
