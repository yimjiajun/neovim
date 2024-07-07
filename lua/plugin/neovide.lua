if vim.g.neovide == nil then return {} end

local function setup()
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

    if vim.g.neovide_cursor_vfx_mode ~= nil then vim.g.neovide_cursor_vfx_opacity = 100.0 end

    vim.opt.title = true
    vim.opt.titlestring = "JunVim" .. "@" .. vim.fn.getcwd()
end

return {Setup = setup}
