local function setup_highlight()
    local colors = {
        GitSignsChange = { link = 'Normal' },
        GitSignsAdd = { link = '@comment.warning' }
    }

    for n, c in pairs(colors) do
        vim.api.nvim_set_hl(0, tostring(n), c)
    end
end

local function setup()
    require('gitsigns').setup {
        signs = {
            add = { text = '┃' },
            change = { text = '┃' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '┆' }
        },
        signs_staged = {
            add = { text = '┃' },
            change = { text = '┃' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '┆' }
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = { interval = 1000, follow_files = true },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
            delay = 0,
            ignore_whitespace = false
        },
        current_line_blame_formatter = '<author>(<author_time:%Y-%m-%d>):  <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
        on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end)

            map('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end)

            -- Actions
            map('n', '<leader>gGn', gitsigns.next_hunk)
            map('n', '<leader>gGp', gitsigns.prev_hunk)
            map({ 'n', 'v' }, '<leader>gGss', function()
                gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
            end)
            map({ 'n', 'v' }, '<leader>gGsr', function()
                gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
            end)
            map('n', '<leader>gGsS', gitsigns.stage_buffer)
            map('n', '<leader>gGsu', gitsigns.undo_stage_hunk)
            map('n', '<leader>gGsR', gitsigns.reset_buffer)
            map('n', '<leader>gGsp', gitsigns.preview_hunk)
            map('n', '<leader>gGba', function()
                gitsigns.blame_line { full = true }
            end)
            map('n', '<leader>gGbb', gitsigns.toggle_current_line_blame)
            map('n', '<leader>gGdd', gitsigns.diffthis)
            map('n', '<leader>gGdp', function()
                gitsigns.diffthis('~')
            end)
            map('n', '<leader>gGtd', gitsigns.toggle_deleted)
            map('n', '<leader>gGtw', gitsigns.toggle_word_diff)
            map('n', '<leader>gGts', gitsigns.toggle_signs)
            map('n', '<leader>gGtl', gitsigns.toggle_linehl)
            map('n', '<leader>gGtn', gitsigns.toggle_numhl)

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }

    if pcall(require, "which-key") then
        local wk = require("which-key")
        wk.add({
            mode = { "n" },
            { "<leader>gG", group = "GitSign" },
            { "<leader>gGb", group = "Blame" },
            { "<leader>gGba", desc = "line" },
            { "<leader>gGbb", desc = "toggle current line blame" },
            { "<leader>gGd", group = "Diff" },
            { "<leader>gGdd", desc = "diffthis" },
            { "<leader>gGdp", desc = "diffthis ~" },
            { "<leader>gGn", desc = "next hunk" },
            { "<leader>gGp", desc = "previous hunk" },
            { "<leader>gGs", group = "Stage", mode = { "n", "v" } },
            { "<leader>gGsR", desc = "reset buffer" },
            { "<leader>gGsS", desc = "buffer" },
            { "<leader>gGsp", desc = "preview hunk" },
            { "<leader>gGsr", desc = "reset", mode = { "n", "v" } },
            { "<leader>gGss", desc = "hunk", mode = { "n", "v" } },
            { "<leader>gGsu", desc = "undo" },
            { "<leader>gGt", group = "Toggle" },
            { "<leader>gGtd", desc = "toggle deleted" },
            { "<leader>gGtl", desc = "toggle linehl" },
            { "<leader>gGtn", desc = "toggle numhl" },
            { "<leader>gGts", desc = "toggle signs" },
            { "<leader>gGtw", desc = "toggle word diff" }
        })
    end

    setup_highlight()
end

return { Setup = setup }
