local colors = require("gruvbox-baby.colors").config()

vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_transparent_mode = 0
vim.g.gruvbox_baby_function_style = "bold"
vim.g.gruvbox_baby_keyword_style = "italic"
vim.g.gruvbox_baby_telescope_theme = 0
vim.g.gruvbox_baby_use_original_palette = 0

if vim.g.gruvbox_baby_transparent_mode == 0 then
	vim.g.gruvbox_baby_highlights = {
		Visual = {bg = colors.background},
		CursorLine = {bg = colors.dark},

		Normal = {bg = colors.dark0},
		NormalNC = {bg = '#000000'},
		NormalFloat = {bg = 'none'},
		FloatBorder = {bg = 'none'},
		StatusLine = {bg = 'none'},
		SignColumn = {bg ='none'},
		TelescopePreviewTitle = {fg = colors.dark0, bg = colors.forest_green},
		TelescopePreviewNormal = {bg = colors.dark0},
		TelescopePreviewBorder = {bg = colors.dark0},
		TelescopeResultsTitle = {fg = colors.dark0, bg = colors.forest_green},
		TelescopeResultsBorder = {bg = colors.dark0},
		TelescopeResultsNormal = {bg = colors.dark0},
		TelescopePromptTitle = {fg = colors.dark0, bg = colors.forest_green},
		TelescopePromptNormal = {bg = colors.background},
		TelescopePromptBorder = {bg = colors.background},
	}
else
	vim.g.gruvbox_baby_highlights = {
		Visual = {bg = colors.background},
		CursorLine = {bg = colors.dark},

		StatusLine = {bg = 'none'},
	}
end

vim.cmd[[colorscheme gruvbox-baby]]
