local chatgpt_status = false

local function setup_chatgpt()
    local chatgpt_key = vim.fn.system("pass show chatgpt/nvim 2>/dev/null")

    if vim.v.shell_error ~= 0 then
        vim.notify("ChatGPT: API key not found, not able run", vim.log.levels.ERROR)
        return false
    end

    require("chatgpt").setup({
        api_key_cmd = "echo " .. chatgpt_key,
        yank_register = "+",
        edit_with_instructions = {
            diff = false,
            keymaps = {
                accept = "<C-y>",
                toggle_diff = "<C-d>",
                toggle_settings = "<C-o>",
                cycle_windows = "<Tab>",
                use_output_as_input = "<C-i>"
            }
        },
        chat = {
            welcome_message = "Welcome to ChatGPT",
            loading_text = "Loading, please wait ...",
            question_sign = "",
            answer_sign = "ﮧ",
            max_line_length = 120,
            sessions_window = {
                border = {style = "rounded", text = {top = " Sessions "}},
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
                }
            },
            keymaps = {
                close = {"<C-c>"},
                yank_last = "<C-y>",
                yank_last_code = "<C-k>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                new_session = "<C-n>",
                cycle_windows = "<Tab>",
                cycle_modes = "<C-f>",
                select_session = "<Space>",
                rename_session = "r",
                delete_session = "d",
                draft_message = "<C-x>",
                toggle_settings = "<C-o>",
                toggle_message_role = "<C-r>",
                toggle_system_role_open = "<C-s>"
            }
        },
        popup_layout = {
            default = "center",
            center = {width = "90%", height = "90%"},
            right = {width = "30%", width_settings_open = "50%"}
        },
        popup_window = {
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {top = " ChatGPT "}
            },
            win_options = {
                wrap = true,
                linebreak = true,
                foldcolumn = "1",
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
            },
            buf_options = {filetype = "markdown"}
        },
        system_window = {
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {top = " SYSTEM "}
            },
            win_options = {
                wrap = true,
                linebreak = true,
                foldcolumn = "2",
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
            }
        },
        popup_input = {
            prompt = "  ",
            border = {
                highlight = "FloatBorder",
                style = "rounded",
                text = {top_align = "center", top = " Prompt "}
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
            },
            submit = "<C-Enter>",
            submit_n = "<Enter>"
        },
        settings_window = {
            border = {style = "rounded", text = {top = " Settings "}},
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
            }
        },
        openai_params = {
            model = "gpt-3.5-turbo",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 300,
            temperature = 0,
            top_p = 1,
            n = 1
        },
        openai_edit_params = {
            model = "code-davinci-edit-001",
            temperature = 0,
            top_p = 1,
            n = 1
        },
        actions_paths = {},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv"
    })

    chatgpt_status = true

    return chatgpt_status
end

local function init_chatgpt()
    if not chatgpt_status then return setup_chatgpt() end

    return chatgpt_status
end

local function open_chatgpt()
    if not init_chatgpt() then return end

    vim.cmd([[silent! ChatGPT]])
end

local function open_chatgpt_action()
    if not init_chatgpt() then return end

    vim.cmd([[silent! ChatGPTActAs]])
end

local function open_chatgpt_edit_instructions()
    if not init_chatgpt() then return end

    vim.cmd([[silent! ChatGPTEditWithInstructions]])
end

local function setup()
    local function setup_keymap()
        local keymap = vim.api.nvim_set_keymap
        local opts = {noremap = true, silent = true}
        local prefix_key = "<leader>gC"

        keymap('n', prefix_key .. 'c', [[<cmd> lua require('plugin.chatgpt').Open() <CR>]], opts)
        keymap('n', prefix_key .. 'a', [[<cmd> lua require('plugin.chatgpt').OpenAction() <CR>]], opts)
        keymap('n', prefix_key .. 'i', [[<cmd> lua require('plugin.chatgpt').OpenEditInstructions() <CR>]], opts)

        if pcall(require, "which-key") then
            local wk = require("which-key")
            local wk_mode = {mdoe = "n", prefix = "<leader>g"}

            wk.register({
                C = {
                    name = "ChatGPT",
                    c = "Open prompt",
                    a = "Act Selection",
                    i = "Instructions"
                }
            }, wk_mode)
        end
    end

    setup_keymap()
end

return {
    Open = open_chatgpt,
    OpenAction = open_chatgpt_action,
    OpenEditInstructions = open_chatgpt_edit_instructions,
    Setup = setup
}
