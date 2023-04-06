-- To disable the plugin
vim.g.loaded_nvimgdb = 1
-- :GdbStart and :GdbStartLLDB use find and the cmake file API to try to tab-complete the command with the executable for the current file. To disable this set g:nvimgdb_use_find_executables or g:nvimgdb_use_cmake_to_find_executables to 0.
-- The behaviour of the plugin can be tuned by defining specific variables. For instance, you could overload some command keymaps:

-- We're going to define single-letter keymaps, so don't try to define them
-- in the terminal window. The debugger CLI should continue accepting text commands.
local function nvim_gdb_no_t_keymaps()
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', '<c-\\><c-n>', {silent = true})
end

vim.g.nvimgdb_config_override = {
  key_next = 'n',
  key_step = 's',
  key_finish = 'f',
  key_continue = 'c',
  key_until = 'u',
  key_breakpoint = 'b',
  set_tkeymaps = nvim_gdb_no_t_keymaps,
}

-- Usage : https://github.com/sakhnik/nvim-gdb#usage
