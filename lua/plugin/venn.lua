function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    local keymap = vim.api.nvim_buf_set_keymap
    local opts = {noremap = true, silent = true}

    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd [[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        keymap(0, "n", "J", "<C-v>j:VBox<CR>", opts)
        keymap(0, "n", "K", "<C-v>k:VBox<CR>", opts)
        keymap(0, "n", "L", "<C-v>l:VBox<CR>", opts)
        keymap(0, "n", "H", "<C-v>h:VBox<CR>", opts)
        -- draw a box by pressing "f" with visual selection
        keymap(0, "v", "f", ":VBox<CR>", opts)
        vim.api.nvim_echo({{'[Enable] Draw Diagram', 'None'}}, false, {})
    else
        vim.cmd [[setlocal ve=]]
        vim.cmd [[mapclear <buffer>]]
        vim.b.venn_enabled = nil
        vim.api.nvim_echo({{'[Disable] Draw Diagram', 'None'}}, false, {})
    end
end

local function setup()
    local function setup_keymap()
        local keymap = vim.api.nvim_set_keymap
        local opts = {noremap = true, silent = true}
        local prefix_key = "<leader>g"

        keymap('n', prefix_key .. 'v', ":lua Toggle_venn()<CR>", opts)

        if pcall(require, 'which-key') then
            local wk = require('which-key')

            wk.register({v = "Venn (toggle draw diagram)"}, {
                mode = "n",
                prefix = prefix_key
            })
        end
    end

    setup_keymap()
end

return {Setup = setup}
