local function setting_key_gotopreview()
	vim.api.nvim_set_keymap('n', 'gpr', [[<cmd> lua require('goto-preview').goto_preview_references() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('n', 'gpd', [[<cmd> lua require('goto-preview').goto_preview_definition() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('n', 'gpi', [[<cmd> lua require('goto-preview').goto_preview_implementation() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('n', 'gpv', [[<cmd> lua require('goto-preview').goto_preview_type_definition() <CR>]], { silent = true })
	vim.api.nvim_set_keymap('n', 'gpc', [[<cmd> lua require('goto-preview').close_all_win() <CR>]], { silent = true })

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ name = "preview",
			r = "references",
			d = "definition",
			i = "implementation",
			v = "type definition",
			c = "close all",
		}, { mode = 'n', prefix = "gp" })
	end
end

require('goto-preview').setup {
  width = 110; -- Width of the floating window
  height = 15; -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
  default_mappings = false; -- Bind default mappings
  debug = false; -- Print debug information
  opacity = 0; -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = true; -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  references = { -- Configure the telescope UI for slowing the references cycling window.
	  telescope = require('telescope.themes').get_ivy({ hide_preview = false })
  };
  focus_on_open = true; -- Focus the floating window when opening it.
  dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

setting_key_gotopreview()