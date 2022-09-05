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
		-- fg = '#928374',
		-- bg = '#1F2223',
		base1 = '#272a30',
		base2 = '#26292C',
		base3 = '#2E323C',
		base4 = '#333842',
		base5 = '#4d5154',
		base6 = '#9ca0a4',
		base7 = '#b1b1b1',
		border = '#a1b5b1',
		fg = '#b1b1b1',
		bg = '#000000',
		black ='#1B1B1B',
		skyblue = '#458588',
		cyan = '#83a597',
		green = '#a6e22e',
		oceanblue = '#1d2021',
		magenta = '#fb4934',
		orange = '#fabd2f',
		red = '#cc241d',
		violet = '#b16286',
		white = '#ebdbb2',
		yellow = '#d79921',
		diff_add = '#262626',
		diff_change = '#121212',
		diff_remove= '#5f0000',
		diff_text = '#000000',
	}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}
