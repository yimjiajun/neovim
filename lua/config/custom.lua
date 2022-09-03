require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c", "cpp", "cmake",
		"bash",
		"lua",
		"make", "markdown", "markdown_inline",
		"python", "yaml", "vim"
	},
}

require('session_manager').setup({
  autoload_mode = require('session_manager.config').AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
})

--  require('which-key').setup {
-- 		plugins = {
-- 			marks = true, -- shows a list of your marks on ' and `
-- 			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
-- 			spelling = {
-- 				enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
-- 				suggestions = 20, -- how many suggestions should be shown in the list?
-- 			},
-- 			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
-- 			-- No actual key bindings are created
-- 			presets = {
-- 				operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
-- 				motions = true, -- adds help for motions
-- 				text_objects = true, -- help for text objects triggered after entering an operator
-- 				windows = true, -- default bindings on <c-w>
-- 				nav = true, -- misc bindings to work with windows
-- 				z = true, -- bindings for folds, spelling and others prefixed with z
-- 				g = true, -- bindings for prefixed with g
-- 			},
-- 		},
-- 		icons = {
-- 			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
-- 			separator = ">", -- symbol used between a key and it's label
-- 			group = "+", -- symbol prepended to a group
-- 		},
-- 		popup_mappings = {
-- 			scroll_down = '<c-d>', -- binding to scroll down inside the popup
-- 			scroll_up = '<c-u>', -- binding to scroll up inside the popup
-- 		},
-- 		window = {
-- 			border = "shadow", -- none, single, double, shadow
-- 			position = "bottom", -- bottom, top
-- 			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
-- 			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
-- 			winblend = 0
-- 		},
-- 		layout = {
-- 			height = { min = 4, max = 25 }, -- min and max height of the columns
-- 			width = { min = 20, max = 50 }, -- min and max width of the columns
-- 			spacing = 5, -- spacing between columns
-- 			align = "center", -- align columns left, center or right
-- 		},
-- 		ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
-- 		show_help = true, -- show help message on the command line when the popup is visible
-- 		triggers = "auto", -- automatically setup triggers
-- }

require('onedark').setup  {
    -- Main options --
    style = 'warmer', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = true,  -- Show/hide background

    -- toggle theme style ---
    toggle_style_key = "<leader>tO", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
}
