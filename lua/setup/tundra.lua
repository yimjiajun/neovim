local setup = {
  transparent_background = true,
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
			-- Normal = { bg = '#000000' },
			-- NormalNC = { bg = '#000000' },
			Visual = { bg = '#1f2937', fg = '#f9fafb'},
			TelescopePreviewBorder = { fg = '#f9fafb',  bg = 'none'},
			TelescopePreviewNormal = { bg = 'none'},
			TelescopePromptBorder = { fg = '#f9fafb',  bg = 'none'},
			TelescopePromptNormal = { bg = 'none'},
			TelescopeResultsBorder = { fg = '#f9fafb', bg = 'none'},
			TelescopeResultsNormal = { bg = 'none'},
			TelescopeResultsTitle = { bg = '#b5e8b0' },
			NormalFloat = { bg = 'none' },
			NormalFloatNC = { bg = 'none' },
		},
  },
};


if vim.g.custom.theme == 'tundra' then
	if vim.g.custom.transparent_background == 0 then
		setup = {
			transparent_background = false,
			overwrite = {
				highlights = {
					Normal = { bg = '#000000' },
					NormalNC = { bg = '#000000' },
					TelescopePreviewBorder = { fg = '#f9fafb',  bg = '#000000'},
					TelescopePreviewNormal = { bg = '#000000'},
					TelescopePromptBorder = { fg = '#f9fafb',  bg = '#000000'},
					TelescopePromptNormal = { bg = '#000000'},
					TelescopeResultsBorder = { fg = '#f9fafb', bg = '#000000'},
					TelescopeResultsNormal = { bg = '#000000'},
					TelescopeResultsTitle = { bg = '#b5e8b0' },
				},
			},
		};
	end

	require('nvim-tundra').setup(setup)

	vim.opt.background = 'dark'
	vim.cmd[[colorscheme tundra]]
end
