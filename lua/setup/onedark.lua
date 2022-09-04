-- Lua
require('onedark').setup  {
    -- Main options --
    style = 'warmer', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = true,  -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = "<leader>tO", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },

	-- Custom Highlights --
    colors = {
		fg = '#928374',
		bg = '#1F2223',
		base1 = '#272a30',
		base2 = '#26292C',
		base3 = '#2E323C',
		base4 = '#333842',
		base5 = '#4d5154',
		base6 = '#9ca0a4',
		base7 = '#b1b1b1',
		border = '#a1b5b1',
		brown = '#504945',
		white = '#f8f8f0',
		grey = '#8F908A',
		black = '#000000',
		pink = '#f92672',
		green = '#a6e22e',
		aqua = '#66d9ef',
		yellow = '#e6db74',
		orange = '#fd971f',
		purple = '#ae81ff',
		red = '#e95678',
		diff_add = '#3d5213',
		diff_remove = '#4a0f23',
		diff_change = '#27406b',
		diff_text = '#23324d',
	}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}
