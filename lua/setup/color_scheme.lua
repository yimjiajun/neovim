local function setup_gruvbox_baby()
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

local function setup_gruvbox()
	local c = require("gruvbox.palette").colors
	local cs = vim.g.custom.colorscheme
	-- setup must be called before loading the colorscheme
	-- Default options:
	require("gruvbox").setup({
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
			strings = true,
			comments = true,
			operators = false,
			folds = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = true,
		invert_intend_guides = false,
		inverse = true, -- invert background for search, diffs, statuslines and errors
		contrast = "hard", -- can be "hard", "soft" or empty string
		palette_overrides = {},
		overrides = {
			SignColumn = { bg = c.dark0_hard },
			NormalFloat = { bg = c.dark0_soft },
			FloatShadow = { bg = '#000000' },
			Search = { bold = true },
			Pmenu = { bg = c.dark0 },
			PmenuSel = { bg = c.light2, fg = c.dark0 },
			StatusLine = { bg = c.dark0_hard, fg = c.light2, bold = true, reverse = false},
			StatusLineNC = { bg = c.dark0_hard, fg = c.light4, italic = true, reverse = false},
			TabLine = { bg = c.dark0, fg = c.light4,  reverse = false},
			TabLineNC = { bg = c.dark0, fg = c.light4,  reverse = false},
			TabLineFill = { bg = c.dark0_hard, reverse = false},
			TabLineSel = { bold = true, reverse = true },
			TelescopeSelection = {bg = c.light2, fg = c.dark0_hard, bold = true},
			TelescopePreviewTitle = {bg = c.dark0_hard, bold = true},
			TelescopePreviewNormal = {bg = c.dark0},
			TelescopePreviewBorder = {bg = c.dark0},
			TelescopeResultsTitle = {bg = c.dark0, bold = true},
			TelescopeResultsNormal = {bg = c.dark0_soft},
			TelescopeResultsBorder = {bg = c.dark0_soft},
			TelescopePromptTitle = {bg = c.dark0_soft, bold = true},
			TelescopePromptNormal = {bg = c.dark1,  bold = true},
			TelescopePromptBorder = {bg = c.dark1},
			GitSignsAdd = {bg = c.dark0_hard, fg = c.neutral_yellow},
			GitSignsChange = {bg = c.dark0_hard, fg = c.neutral_orange},
			GitSignsDelete = {bg = c.dark0_hard, fg = c.neutral_red},
			CocErrorSign = {bg = c.dark0_hard, fg = c.neutral_red},
			CocWarningSign = {bg = c.dark0_hard, fg = c.neutral_yellow},
			CocInfoSign = {bg = c.dark0_hard, fg = c.neutral_blue},
			CocHintSign = {bg = c.dark0_hard, fg = c.neutral_aqua},
		},
		dim_inactive = false,
		transparent_mode = false,
	})

	if cs.theme == "gruvbox" then
		vim.cmd("colorscheme gruvbox")
	end
end

return {
	GruvboxBaby = setup_gruvbox_baby,
	Gruvbox = setup_gruvbox,
	OneDarkPro = setup_onedark_pro,
}
