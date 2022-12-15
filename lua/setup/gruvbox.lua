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
	},
})

require("gruvbox").setup({
	palette_overrides = {
		dark0_hard = "#0C0C0C",
	}
})

if vim.g.custom.theme == 'gruvbox' then
	vim.opt.background = 'dark'
	vim.cmd[[colorscheme gruvbox]]
end

if vim.g.custom.theme == 'gruvbox' then
vim.api.nvim_create_augroup("Gruvbox", { clear = true })
	vim.api.nvim_create_autocmd( "VimEnter", {
		desc = "Sign and TabLine",
		group = "Gruvbox",
		pattern = "*",
		callback = function()
			vim.cmd[[highlight GruvboxGreenSign guibg=bg]]
			vim.cmd[[highlight GruvboxAquaSign guibg=bg]]
			vim.cmd[[highlight GruvboxBlueSign guibg=bg]]
			vim.cmd[[highlight GruvboxOrangeSign guibg=bg]]
			vim.cmd[[highlight GruvboxYellowSign guibg=bg]]
			vim.cmd[[highlight GruvboxRedSign guibg=bg]]
			vim.cmd[[highlight GruvboxPurpleSign guibg=bg]]
			vim.cmd[[highlight TablineFill guibg=bg]]
		end,
	})
end
