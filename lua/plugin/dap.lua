local dap_info = { python = {} }

local function setup_keymap()
    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    local function dap_python_keymap()
        keymap(
            "n",
            "<leader>dPm",
            '<cmd>lua require"dap-python".test_method()<CR>',
            opts
        )
        keymap(
            "n",
            "<leader>dPc",
            '<cmd>lua require"dap-python".test_class()<CR>',
            opts
        )
        keymap(
            "v",
            "<leader>dPs",
            '<cmd>lua require"dap-python".debug_selection()<CR>',
            opts
        )

        if pcall(require, "which-key") then
            local wk = require("which-key")
            local k = {
                { "<leader>dP", group = "Python" },
                { "<leader>dPm", desc = "test method" },
                { "<leader>dPc", desc = "test class" },
                { "<leader>dPs", desc = "debug selection", mode = { "v" } },
            }
            wk.add(k)
        end
    end

    local function init()
        keymap(
            "n",
            "<leader>db",
            '<cmd>lua require"dap".toggle_breakpoint()<CR>',
            opts
        )
        keymap(
            "n",
            "<leader>dB",
            '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
            opts
        )
        keymap("n", "<leader>dd", '<cmd>lua require"dap".continue()<CR>', opts)
        keymap(
            "n",
            "<leader>dD",
            '<cmd>lua require"dap".disconnect()<CR>',
            opts
        )
        keymap(
            "n",
            "<leader>do",
            '<cmd>lua require"dap".repl.toggle()<CR>',
            opts
        )
        keymap("n", "<leader>ds", '<cmd>lua require"dap".step_over()<CR>', opts)
        keymap("n", "<leader>di", '<cmd>lua require"dap".step_into()<CR>', opts)
        keymap("n", "<leader>dQ", '<cmd>lua require"dap".step_back()<CR>', opts)
        keymap("n", "<leader>dq", '<cmd>lua require"dap".step_out()<CR>', opts)
        keymap("n", "<leader>dT", '<cmd>lua require"dap".terminate()<CR>', opts)
        keymap("n", "<leader>dR", '<cmd>lua require"dap".restart()<CR>', opts)
        keymap(
            "n",
            "<leader>dC",
            '<cmd>lua require"dap".clear_breakpoints()<CR>',
            opts
        )
        keymap(
            "n",
            "<leader>dl",
            '<cmd>lua require"dap".list_breakpoints()<CR>',
            opts
        )
        keymap("n", "<leader>da", '<cmd>lua require"dap".run()<CR>', opts)
        keymap("n", "<leader>dA", '<cmd>lua require"dap".run_last()<CR>', opts)
        keymap("n", "<leader>dp", '<cmd>lua require"dap".pause()<CR>', opts)
        keymap("n", "<leader>dg", '<cmd>lua require"dap".goto_()<CR>', opts)
        keymap("n", "<leader>dS", '<cmd>lua require"dap".status()<CR>', opts)
        keymap("n", "<leader>dp", '<cmd>lua require"dap".pause()<CR>', opts)

        if pcall(require, "which-key") then
            local wk = require("which-key")
            local k = {
                { "<leader>d", group = "Debugger" },
                { "<leader>dA", desc = "run last" },
                { "<leader>dB", desc = "toggle conditional breakpoint" },
                { "<leader>dC", desc = "clear all breakpoints" },
                { "<leader>dD", desc = "disconnect" },
                { "<leader>dQ", desc = "step back" },
                { "<leader>dR", desc = "restart" },
                { "<leader>dT", desc = "terminate" },
                { "<leader>da", desc = "run" },
                { "<leader>db", desc = "toggle breakpoint" },
                { "<leader>dd", desc = "continue" },
                { "<leader>dg", desc = "goto" },
                { "<leader>di", desc = "step into" },
                { "<leader>dl", desc = "list breakpoints" },
                { "<leader>do", desc = "open repl" },
                { "<leader>dp", desc = "pause" },
                { "<leader>dq", desc = "step out" },
                { "<leader>ds", desc = "step over" },
            }
            wk.add(k, { mode = "n" })
        end
    end

    return { Python = dap_python_keymap, Init = init }
end

local function dap_get_info(client)
    local tbl = {}
    local dap_tbl = { { client = "python", info = dap_info.python } }

    for _, v in pairs(dap_tbl) do
        if v.client == client then
            table.insert(tbl, v.info)
        end
    end

    return tbl
end

local function dap_insert_info(tbl, client)
    local dap_tbl = { { client = "python", info = dap_info.python } }

    if (client == nil) or (tbl == nil) then
        return
    end

    for _, v in pairs(dap_tbl) do
        if v.client == client then
            table.insert(v.info, tbl)
            return
        end
    end
end

local function setup()
    setup_keymap().Init()
end

return {
    Keymap = setup_keymap,
    InsertInfo = dap_insert_info,
    GetInfo = dap_get_info,
    Setup = setup,
}
