local prefix_key = '<leader>gc'
local config =  {
    model = "gpt-4", -- :CoplotChatModels
    prompts = {
        CommitStaged = {
            prompt = [[Write commit message for the change with commitizen convention.]] ..
                [[Make sure the title has maximum 50 characters and message is wrapped at 72 characters.]] ..
                [[Wrap the whole message in code block with language gitcommit.]],
            system_prompt = 'Commitizen is a tool that helps you write better commit messages',
            mapping = prefix_key .. 's',
            description = 'Commit staged changes',
            context = 'git:staged',
        },
        ImproveGrammer = {
            prompt = vim.fn.getreg('+') .. string.format("\n%s", "Improve above english grammar without display prompt"),
            system_prompt = 'You are a helpful assistant that improves English grammar',
            mapping = prefix_key .. 'I',
            description = 'Improve English Grammer (clipboard)'
        },
    },
    highlight_selection = false, -- Highlight selection
    window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.9, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.7, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
    },
}
local function setup()
    -- Setup keybindings
    local keymap = vim.keymap.set
    local keymap_options = function(desc)
        return { noremap = true, silent = true, desc = desc }
    end
    local copilotchat_telescope = function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
    end
    for _, mode in ipairs({ 'n', 'v' }) do
        keymap(mode, prefix_key, copilotchat_telescope, keymap_options('Open CopilotChat'))
    end

    require('CopilotChat').setup(config)
    -- Setup which-key mappings
    if pcall(require, 'which-key') then
        local wk = require('which-key')
        local keys = {
            -- default CopilotChat commands
            { "<leader>gc", group = "CopilotChat" },
            { "<leader>gcC", ":CopilotChatToggle<CR>", desc = "Open" },
            { "<leader>gcd", ":CopilotChatDocs<CR>", desc = "Docs" },
            { "<leader>gce", ":CopilotChatExplain<CR>", desc = "Explain" },
            { "<leader>gcf", ":CopilotChatFix<CR>", desc = "Fix" },
            { "<leader>gco", ":CopilotChatOptimize<CR>", desc = "Optimize" },
            { "<leader>gcr", ":CopilotChatReview<CR>", desc = "Review" },
            { "<leader>gct", ":CopilotChatTests<CR>", desc = "Tests" }
        }
        wk.add({ mode = { 'n' }, keys })
        wk.add({ mode = { 'v' }, keys })
    end
end

return { Setup = setup }
