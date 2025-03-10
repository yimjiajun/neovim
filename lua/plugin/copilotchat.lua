local function setup()
    -- Setup CopilotChat
    require('CopilotChat').setup()
    -- Setup keybindings
    local keymap = vim.keymap.set
    local keymap_options = function(desc)
        return { noremap = true, silent = true, desc = desc }
    end
    local key = '<leader>gc'
    local copilotchat_telescope = function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
    end
    for _, mode in ipairs({ 'n', 'v' }) do
        keymap(mode, key, copilotchat_telescope, keymap_options('Open CopilotChat'))
    end
    -- Setup which-key mappings
    if pcall(require, 'which-key') then
        local wk = require('which-key')
        local keys = {
            { "<leader>gc", group = "CopilotChat" },
            { "<leader>gcC", ":CopilotChatToggle<CR>", desc = "Open" },
            { "<leader>gcd", ":CopilotChatDocs<CR>", desc = "Docs" },
            { "<leader>gce", ":CopilotChatExplain<CR>", desc = "Explain" },
            { "<leader>gcf", ":CopilotChatFix<CR>", desc = "Fix" },
            { "<leader>gco", ":CopilotChatOptimize<CR>", desc = "Optimize" },
            { "<leader>gcr", ":CopilotChatReview<CR>", desc = "Review" },
            { "<leader>gcs", ":CopilotChatCommit<CR>", desc = "Commit" },
            { "<leader>gct", ":CopilotChatTests<CR>", desc = "Tests" }
        }
        wk.add({ mode = { 'n' }, keys })
        wk.add({ mode = { 'v' }, keys })
    end
end

return { Setup = setup }
