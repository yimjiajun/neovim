-- setup must be called before loading the colorscheme
-- Default options:
local M = {}

M.colors = {	-- this color provided by plugin
  dark0_hard = "#1d2021",
  dark0 = "#282828",
  dark0_soft = "#32302f",
  dark1 = "#3c3836",
  dark2 = "#504945",
  dark3 = "#665c54",
  dark4 = "#7c6f64",
  light0_hard = "#f9f5d7",
  light0 = "#fbf1c7",
  light0_soft = "#f2e5bc",
  light1 = "#ebdbb2",
  light2 = "#d5c4a1",
  light3 = "#bdae93",
  light4 = "#a89984",
  bright_red = "#fb4934",
  bright_green = "#b8bb26",
  bright_yellow = "#fabd2f",
  bright_blue = "#83a598",
  bright_purple = "#d3869b",
  bright_aqua = "#8ec07c",
  bright_orange = "#fe8019",
  neutral_red = "#cc241d",
  neutral_green = "#98971a",
  neutral_yellow = "#d79921",
  neutral_blue = "#458588",
  neutral_purple = "#b16286",
  neutral_aqua = "#689d6a",
  neutral_orange = "#d65d0e",
  faded_red = "#9d0006",
  faded_green = "#79740e",
  faded_yellow = "#b57614",
  faded_blue = "#076678",
  faded_purple = "#8f3f71",
  faded_aqua = "#427b58",
  faded_orange = "#af3a03",
  gray = "#928374",
}

if vim.g.custom.theme == 'gruvbox' then
	local setup = {}
	local bg_color = "#000000"
	local transparent_mode = false
	local contrast = "hard"

	vim.o.bg = vim.g.custom.background

	if vim.g.custom.transparent_background == 1 then
		transparent_mode = true
	end

	if vim.g.gruvbox_theme.contrast == 1 then
		contrast = 'soft'
	end

	if vim.o.bg == 'dark' then
		if contrast == 'hard' then
			bg_color = M.colors.dark0_hard
		else
			bg_color = M.colors.dark0_soft
		end
	else
		if contrast == 'hard' then
			bg_color = M.colors.light0_hard
		else
			bg_color = M.colors.light0_soft
		end
	end

	setup = {
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
		invert_tabline = false,
		invert_intend_guides = false,
		inverse = true, -- invert background for search, diffs, statuslines and errors
		contrast = contrast, -- can be "hard", "soft" or empty string
		dim_inactive = true,
		transparent_mode = transparent_mode,
		overrides = {
			NormalFloat = {bg = bg_color},
			NormalNC = {bg = bg_color},
			TabLineFill = {bg = bg_color},
			SignColumn = {bg = bg_color},
			GruvboxAquaSign = {bg = bg_color},
			GruvboxBlueSign = {bg = bg_color},
			GruvboxOrangeSign = {bg = bg_color},
			GruvboxYellowSign = {bg = bg_color},
			GruvboxRedSign = {bg = bg_color},
			GruvboxPurpleSign = {bg = bg_color},
			GruvboxGreenSign = {bg = bg_color},
		},
		palette_overrides = {
			-- dark0_hard = "#0C0C0C",
		}
	}

	require("gruvbox").setup(setup)

	vim.cmd("colorscheme gruvbox-material")
end
