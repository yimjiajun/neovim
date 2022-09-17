if vim.g.custom.lualine_simple == 0 then
	local config = {
		options = {
			icons_enabled = true,
			theme = 'auto',
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' },
			disabled_filetypes = {
				statusline = { 'NvimTree', 'packer', 'alpha', 'plugin', 'aerial', 'tagbar' },
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = false,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			}
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch', 'diff', 'diagnostics' },
			lualine_c = { 'filename' },
			lualine_x = { 'encoding', 'fileformat', 'filetype' },
			lualine_y = { 'progress' },
			lualine_z = { 'location' }
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { 'filename' },
			lualine_x = { 'location' },
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {}
	}

	-- Now don't forget to initialize lualine
	require('lualine').setup(config)

else -- if vim.g.custom.lualine_simple == 0 then

	-- Eviline config for lualine
	-- Author: shadmansaleh
	-- Credit: glepnir
	local lualine = require('lualine')

	-- Color table for highlights
	-- stylua: ignore
	local colors = {
		bg       = '#121212',
		fg       = '#bbc2cf',
		yellow   = '#ECBE7B',
		cyan     = '#008080',
		darkblue = '#081633',
		green    = '#98be65',
		orange   = '#FF8800',
		violet   = '#a9a1e1',
		magenta  = '#c678dd',
		blue     = '#87d7ff',
		red      = '#ec5f67',
		black    = '#000000',
	}

	local side_colors = {
		n = '#9e9e9e',
		i = colors.black,
		v = colors.black,
		[''] = colors.black,
		V = colors.black,
		c = colors.black,
		no = colors.black,
		s = colors.black,
		S = colors.black,
		[''] = colors.black,
		ic = colors.black,
		R = colors.black,
		Rv = colors.black,
		cv = colors.black,
		ce = colors.black,
		r = colors.black,
		rm = colors.black,
		['r?'] = colors.black,
		['!'] = colors.black,
		t = colors.black,
	}

	local fg_colors = {
		n = '#9e9e9e',
		-- i = '#d7ff00',
		i = '#ffff87',
		v = colors.blue,
		[''] = colors.blue,
		V = colors.blue,
		c = colors.magenta,
		no = colors.red,
		s = colors.orange,
		S = colors.orange,
		[''] = colors.orange,
		ic = colors.green,
		R = colors.violet,
		Rv = colors.violet,
		cv = colors.red,
		ce = colors.red,
		r = colors.cyan,
		rm = colors.cyan,
		['r?'] = colors.cyan,
		['!'] = colors.red,
		t = colors.reds,
	}

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand('%:p:h')
			local gitdir = vim.fn.finddir('.git', filepath .. ';')
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	-- Config
	local config = {
		options = {
			-- Disable sections and component separators
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
			disabled_filetypes = {
				statusline = { 'NvimTree', 'packer', 'alpha', 'plugin', 'aerial', 'tagbar' },
				winbar = {},
			},
			always_divide_middle = true,
			globalstatus = true,
			theme = {
				-- We are going to use lualine_c an lualine_x as left and
				-- right section. Both are highlighted by c theme .  So we
				-- are just setting default looks o statusline
				normal = { c = { fg = colors.fg, bg = colors.bg } },
				inactive = { c = { fg = colors.fg, bg = '#080808' } },
			},
		},
		sections = {
			-- these are to remove the defaults
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			-- These will be filled later
			lualine_c = {},
			lualine_x = {},
		},
		inactive_sections = {
			-- these are to remove the defaults
			lualine_a = {},
			lualine_b = {},
			lualine_y = {},
			lualine_z = {},
			lualine_c = {},
			lualine_x = {},
		},
	}
	-- Inserts a component in lualine_c at left section
	local function ins_left(component)
		table.insert(config.sections.lualine_c, component)
	end

	-- Inserts a component in lualine_x ot right section
	local function ins_right(component)
		table.insert(config.sections.lualine_x, component)
	end

	ins_left {
		function()
			return '▊'
		end,
		color = function()
			-- auto change color according to neovims mode
			return { fg = fg_colors[vim.fn.mode()] }
		end,
		padding = { left = 0, right = 2 }, -- We don't need space before this
	}

	ins_left {
		-- mode component
		function()
			return ''
		end,
		color = function()
			-- auto change color according to neovims mode
			return { fg = fg_colors[vim.fn.mode()] }
		end,
		padding = { left = 1, right = 4 },
	}

	ins_left {
		'filename',
		icon = '',
		cond = conditions.buffer_not_empty,
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 1, right = 2 },
	}

	-- ins_left {
	--   -- filesize component
	--   'filesize',
	--   cond = conditions.buffer_not_empty,
	-- icon = '樂',
	-- }

	ins_left {
		'branch',
		icon = '',
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 1, right = 2 },
	}

	ins_left {
		'diff',
		-- Is it me or the symbol for modified us really weird
		symbols = { added = ' ', modified = '柳 ', removed = ' ' },
		diff_color = {
			added = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
			modified = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
			removed = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
		},
		cond = conditions.hide_in_width,
		padding = { left = 0, right = 2 },
	}

	-- Insert mid section. You can make any number of sections in neovim :)
	-- for lualine it's any number greater then 2
	ins_left {
		function()
			return '%='
		end,
	}

	ins_right {
		function()
			local search = vim.fn.searchcount({maxcount = 0}) -- maxcount = 0 makes the number not be capped at 99
			local searchCurrent = search.current
			local searchTotal = search.total

			if searchCurrent > 0 then
					return " "..vim.fn.getreg("/").." ["..searchCurrent.."/"..searchTotal.."]"
			else
				return ""
			end
		end,
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 0, right = 1 },
	}

	ins_right {
		'diagnostics',
		sources = { 'nvim_diagnostic' },
		symbols = { error = ' ',
			warn = ' ',
			info = ' ',
		},
		diagnostics_color = {
			error = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
			warn = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
			info = function()
				return { fg = side_colors[vim.fn.mode()] }
			end,
			padding = { left = 0, right = 0 },
		},
	}
	-- Add components to right sections
	ins_right {
		-- Lsp server name .
		function()
			local msg = 'No Active Lsp'
			local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end,
		icon = ' ',
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 0, right = 1 },
	}

	ins_right {
		'fileformat',
		fmt = string.upper,
		icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 2, right = 1 },
	}

	ins_right {
		'o:encoding', -- option component same as &encoding in viml
		fmt = string.upper, -- I'm not sure why it's upper case either ;)
		cond = conditions.hide_in_width,
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 2, right = 1 },
	}

	ins_right { 'location',
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 2, right = 1 },
	}

	ins_right { 'progress',
		color = function()
			return { fg = side_colors[vim.fn.mode()], gui = 'bold' }
		end,
		padding = { left = 2, right = 1 },
	}

	ins_right {
		function()
			return '▊'
		end,
		color = function()
			-- auto change color according to neovims mode
			return { fg = fg_colors[vim.fn.mode()] }
		end,
		padding = { left = 2, },
	}

	-- Now don't forget to initialize lualine
	lualine.setup(config)
end -- if vim.g.custom.lualine_simple == 0
