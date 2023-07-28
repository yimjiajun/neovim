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
		CursorLine = {bg = '#273842'},
		NormalFloat = {bg = colors.background},
		FloatBorder = {bg = colors.dark},
		FloatShadow = {bg = colors.dark0},
		FloatShadowThrough = {bg = 'none'},
		StatusLine = {bg = colors.background_light, fg = colors.forest_green},
		SignColumn = {bg ='none'},
		Search = {fg = colors.background_light, bg = colors.clean_green, style = 'bold'},
		TelescopeSelection = {bg = '#273842'},
		TelescopePreviewTitle = {fg = colors.clean_green, bg =colors.dark},
		TelescopePreviewNormal = {bg = colors.dark},
		TelescopePreviewBorder = {bg = colors.dark},
		TelescopeResultsTitle = {fg = colors.clean_green, bg = colors.dark},
		TelescopeResultsNormal = {bg = colors.background},
		TelescopeResultsBorder = {bg = colors.background},
		TelescopePromptTitle = {bg = colors.forest_green, fg = colors.background_light},
		TelescopePromptNormal = {fg = colors.dark0, bg = colors.forest_green},
		TelescopePromptBorder = {fg = colors.dark0, bg = colors.background},
	}
else
	vim.g.gruvbox_baby_highlights = {
		CursorLine = {bg = '#273842'},
		Search = {fg = colors.background_light, bg = colors.clean_green, style = 'bold'},
		TelescopeSelection = {bg = '#273842'},
		TelescopePreviewTitle = {fg = colors.clean_green, bg =colors.dark},
		TelescopeResultsTitle = {fg = colors.clean_green, bg = colors.background},
		TelescopePromptTitle = {fg = colors.clean_green, bg = colors.background_light},
		StatusLine = {bg = 'none'},
		FloatShadow = {bg = 'none'},
		FloatShadowThrough = {bg = 'none'},
	}
end

vim.cmd('colorscheme gruvbox-baby')
vim.cmd('hi FloatShadow blend=30')
