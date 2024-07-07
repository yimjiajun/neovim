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
        operators = {gc = "Comments"},
        key_labels = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            -- ["<space>"] = "SPC",
            -- ["<cr>"] = "RET",
            -- ["<tab>"] = "TAB",
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "|", -- symbol used between a key and it's label
            group = "+ " -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = '<c-d>', -- binding to scroll down inside the popup
            scroll_up = '<c-u>' -- binding to scroll up inside the popup
        },
        window = {
            border = "single", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = {1, 15, 1, 15}, -- extra window margin [top, right, bottom, left]
            padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
            -- winblend = 20
        },
        layout = {
            height = {min = 4, max = 20}, -- min and max height of the columns
            width = {min = 10, max = 40}, -- min and max width of the columns
            spacing = 10, -- spacing between columns
            align = "center" -- align columns left, center or right
        },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
        hidden = {
            "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "
        }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            -- this is mostly relevant for key maps that start with a native binding
            -- most people should not need to change this
            i = {"j", "k"},
            v = {"j", "k"},
            -- customize
            l = {"k", "j"}
        }
    })

    local wk = require("which-key")

    wk.register({
        w = 'buffer',
        q = 'marks',
        h = 'jumplist',
        r = 'registers',
        e = 'explorer',
        E = 'explorer File',
        b = 'build',
        B = 'build latest',
        c = 'quickfix',
        d = 'Debugger',
        s = {
            name = 'Save',
            m = 'mark (buffer)',
            M = 'mark (local)',
            b = 'bookmarks',
            B = 'bookmarks (rename)',
            t = 'todo lists'
        },
        S = {
            name = 'Unload',
            m = 'mark (buffer)',
            M = 'mark (local)',
            u = 'mark (buffers)',
            U = 'mark (universal)',
            b = 'bookmarks',
            B = 'bookmarks (cwd)'
        },
        o = {
            name = 'Open',
            m = 'mark (buffer)',
            u = 'mark (sort buffer)',
            M = 'mark (local)',
            U = 'mark (universal)',
            b = 'bookmarks',
            B = 'bookmarks (all)',
            t = 'todo lists',
            s = 'session',
            S = 'session (selection)'
        },
        v = {
            name = 'View',
            s = {name = 'System', b = 'battery'},
            c = {name = 'Calendar', i = 'interactive'}
        },
        f = {
            name = 'Find',
            f = 'file',
            w = 'word',
            c = 'c',
            C = 'c, cpp, h',
            h = 'h',
            d = 'dts{i}',
            A = 'all (usr input)',
            a = 'all',
            q = 'customize search word',
            k = 'conf',
            K = 'Kconfig',
            m = 'CMakeLists',
            v = 'Vimgrep',
            V = 'Vimgrep - complete word'
        },
        g = {
            name = 'Global Plug',
            g = {
                name = 'Git',
                l = 'log Graph',
                L = 'log',
                H = 'log patch',
                C = 'commit count',
                d = 'diff',
                D = 'diff previous',
                h = 'diff staging',
                s = 'status',
                S = 'status short',
                w = 'white space check',
                p = 'add patch',
                a = 'add',
                A = 'add all',
                c = 'commit'
            }
        },
        t = {
            name = 'Toggle',
            f = 'terminal',
            F = 'scp send',
            s = 'terminal split',
            v = 'terminal vsplit',
            c = 'ctags generator',
            e = 'file format',
            S = '+ Secure Shell Protocol',
            w = {
                name = 'working directory',
                w = 'chg & save current path',
                s = 'save current path',
                r = 'restore from saved path',
                c = 'clear saved path'
            }
        }
    }, {mode = "n", prefix = "<leader>"})

    wk.register({g = {name = 'Global Plug'}}, {mode = 'v', prefix = "<leader>"})

    vim.cmd("highlight default link WhichKeyFloat Normal")
end

return {Setup = setup}
