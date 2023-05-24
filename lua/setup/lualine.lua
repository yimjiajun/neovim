local function lualine_classical()
	local config = {
		options = {
			icons_enabled = false,
			theme = 'ayu_dark',
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' },
			disabled_filetypes = {
				statusline = { 'NvimTree', 'packer', 'alpha', 'plugin', 'aerial', 'tagbar', 'netrw' },
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
			lualine_b = { 'branch', 'diff' },
			lualine_c = { 'filename' },
			lualine_x = { 'encoding', 'fileformat', 'filetype', {'%-=0x%B'}, },
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
end

lualine_classical()

local ret = {
	LualineClassical = lualine_classical,
}

return ret
