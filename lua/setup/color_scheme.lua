local function setup_gruvbox()
	local colors = require("gruvbox-baby.colors").config()
	local cs = vim.g.custom.colorscheme

	vim.g.gruvbox_baby_background_color = "dark"
	vim.g.gruvbox_baby_transparent_mode = cs.transparency and 1 or 0
	vim.g.gruvbox_baby_function_style = "bold"
	vim.g.gruvbox_baby_keyword_style = "italic"
	vim.g.gruvbox_baby_telescope_theme = 0
	vim.g.gruvbox_baby_use_original_palette = 0

	if vim.g.gruvbox_baby_transparent_mode == 0 then
		vim.g.gruvbox_baby_highlights = {
			Visual = {bg = colors.medium_gray},
			CursorLine = {bg = '#273842'},
			NormalFloat = {bg = colors.background},
			FloatBorder = {bg = colors.dark},
			FloatShadow = {bg = colors.dark0},
			FloatShadowThrough = {bg = 'none'},
			StatusLine = {bg = colors.background_light, fg = colors.forest_green, style = 'bold'},
			StatusLineNC = {bg = colors.background_light, fg = colors.dark0},
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

	if cs.theme == "gruvbox-baby" then
		vim.cmd('colorscheme gruvbox-baby')
		vim.cmd('hi FloatShadow blend=30')
	end
end

local function setup_onedark_pro()
	local color = require("onedarkpro.helpers")
	local c = color.get_colors()
	local cs = vim.g.custom.colorscheme

	require("onedarkpro").setup({
		colors = {
		},
		options = {
			transparency = cs.transparency and 1 or 0,
			cursorline = true
		},
		highlights = {
			Comment = { italic = true },
			Directory = { underline = true },
			ErrorMsg = { italic = true, bold = true },
			PmenuSel = { fg = c.black, bg = c.green, bold = true },
			Search = { fg = c.black, bg = c.green, bold = true },
			StatusLine = { fg = c.white, bold = true },
			StatusLineNC = { fg = c.black },
			TelescopePreviewTitle = { fg = c.black, bg = c.white, bold = true },
			TelescopeResultsTitle = { fg = c.black, bg = c.white, bold = true },
			TelescopePromptTitle = { fg = c.black, bg = c.white, bold = true },
		},
		styles = {
			types = "NONE",
			methods = "bold",
			numbers = "NONE",
			strings = "italic",
			comments = "italic",
			keywords = "bold,italic",
			constants = "NONE",
			functions = "bold",
			operators = "NONE",
			variables = "NONE",
			parameters = "NONE",
			conditionals = "NONE",
			virtual_text = "NONE",
		}
	})

	if cs.theme == "onedarkpro" then
		vim.cmd('colorscheme onedark_dark')
	end
end

return {
	GruvboxBaby = setup_gruvbox,
	OneDarkPro = setup_onedark_pro,
}
