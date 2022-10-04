-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  dim_inactive = false,
  transparent_mode = false,
  overrides = {
		NormalFloat = { bg = bg },
	},
})

if vim.g.custom.theme == 'gruvbox' then
	vim.opt.background = 'dark'
	vim.cmd[[colorscheme gruvbox]]
end
