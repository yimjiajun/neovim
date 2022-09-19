require('nvim-tundra').setup({
  transparent_background = false,
  editor = {
    search = {},
    substitute = {},
  },
  syntax = {
    booleans = { bold = true, italic = true },
    comments = { bold = true, italic = true },
    conditionals = {},
    constants = { bold = true },
    functions = {},
    keywords = {},
    loops = {},
    numbers = { bold = true },
    operators = { bold = true },
    punctuation = {},
    strings = {},
    types = { italic = true },
  },
  diagnostics = {
    errors = {},
    warnings = {},
    information = {},
    hints = {},
  },
  plugins = {
    lsp = true,
    treesitter = true,
    cmp = true,
    context = true,
    dbui = true,
    gitsigns = true,
    telescope = true,
  },
  overwrite = {
    colors = {},
    highlights = {
		diffRemoved = { fg = '#d70000', italic = true },
		DiffText = { bg = '#1c1c1c', fg = '#ffffaf', bold = true },
		DiffDelete = { bg = '#5f0000', italic = true },
		DiffAdd = { bg = '#262626', italic = true },
		DiffChange = { bg = '#121212', italic = true },
		Normal = { bg = '#000000' },
		NormalNC = { bg = '#000000' },
		Visual = { bg = '#1f2937', fg = '#f9fafb'},
		-- TelescopePreviewBorder = { fg = '#f9fafb' },
		TelescopePromptBorder = { fg = '#f9fafb' },
		TelescopeResultsBorder = { fg = '#f9fafb' },
		TelescopeResultsTitle = { bg = '#b5e8b0' },
	},
  },
})

vim.opt.background = 'dark'
vim.cmd('colorscheme tundra')
