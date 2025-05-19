if vim.g.neovide == nil then
    return {}
end

local adjust_scale_factor = function(value)
    if value == 0 then
        vim.g.neovide_scale_factor = 1.0
        return
    end

    if vim.g.neovide_scale_factor + value < 0.1 then
        return
    end

    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + value
end

local function setup()
    local prefix_key = '<leader>gn'
    local keymap = vim.keymap.set
    local keymap_options = function(desc)
        return { noremap = true, silent = true, desc = desc }
    end

    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_scroll_animation_length = 1.0
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_no_idle = true
    vim.g.neovide_underline_automatic_scaling = false
    vim.g.neovide_fullscreen = true
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_sizes = 0.5
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_vfx_mode = "ripple"

    if vim.g.neovide_cursor_vfx_mode ~= nil then
        vim.g.neovide_cursor_vfx_opacity = 100.0
    end

    vim.opt.title = true
    vim.opt.titlestring = "JunVim" .. "@" .. vim.fn.getcwd()

    for _, mode in ipairs({ 'n', 'v' }) do
        keymap(mode, prefix_key .. '+', function()
            adjust_scale_factor(0.2)
        end, keymap_options('Increase scale'))

        keymap(mode, prefix_key .. '-', function()
            adjust_scale_factor(-0.2)
        end, keymap_options('Decrease scale'))

        keymap(mode, prefix_key .. '=', function()
            adjust_scale_factor(0.0)
        end, keymap_options('Restore scale'))

        keymap(mode, prefix_key .. 'f', function()
            if (vim.g.neovide_fullscreen == true) then
                vim.g.neovide_fullscreen = false
            else
                vim.g.neovide_fullscreen = true
            end
        end, keymap_options('Toggle fullscreen'))

        keymap(mode, prefix_key .. 'c', function()
            if (vim.g.neovide_cursor_animate_command_line == true) then
                vim.g.neovide_cursor_animate_command_line = false
            else
                vim.g.neovide_cursor_animate_command_line = true
            end
        end, keymap_options('Toggle command line anime'))
    end

    if pcall(require, 'which-key') then
        local wk = require('which-key')
        wk.add({
            { prefix_key , group = "Neovide" },
        })
    end
end

return { Setup = setup }
