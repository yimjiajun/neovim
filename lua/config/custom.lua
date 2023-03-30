vim.g.custom = {
	-- support native nvim LSP ( 0: disabled native nvim LSP and replaced by coc.nvim )
	lsp_support = 1,
	-- display statusline as simple line
	lualine_simple = 1,
	-- display buffer
	buffer_display = 0,
	-- statusline support
	statusline_support = 0,
	-- theme selection [ tundra, gruvbox ]
	theme = 'gruvbox',
	-- background color
	background = 'dark',
	-- transparent background
	transparent_background = 1,
}

if vim.g.custom.theme == 'gruvbox' then
	vim.g.gruvbox_theme = {
		contrast = 0,
	}
end
