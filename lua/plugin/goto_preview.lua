local function setup()
    local function setup_keymap()
        if pcall(require, "which-key") then
            local wk = require("which-key")

            wk.register({
                P = 'close lsp preview',
                p = {
                    name = "Lsp Preview",
                    d = 'definition',
                    i = 'implementation',
                    r = 'references',
                    t = 'type definition'
                }
            }, {mode = "n", prefix = "g"})
        end
    end

    require('goto-preview').setup {
        width = 120, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = {"↖", "─", "┐", "│", "┘", "─", "└", "│"}, -- Border characters of the floating window
        default_mappings = true, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
            telescope = require("telescope.themes").get_dropdown({
                hide_preview = false,
                borderchars = {
                    prompt = {" ", " ", " ", " ", " ", " ", " ", " "},
                    results = {" ", " ", " ", " ", " ", " ", " ", " "},
                    preview = {" ", " ", " ", " ", " ", " ", " ", " "}
                }
            })
        },

        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        -- Whether to set the preview window title as the filename
        preview_window_title = {enable = true, position = "left"}
    }

    setup_keymap()
end

return {Setup = setup}
