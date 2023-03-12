-- 256 xtern color - http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

vim.g.color_gruvbox = {
    fg = '#928374',
    -- bg = '#1F2223',
    bg = '#000000',
    black ='#1B1B1B',
    skyblue = '#458588',
    cyan = '#83a597',
    green = '#689d6a',
    oceanblue = '#1d2021',
    magenta = '#fb4934',
    orange = '#fabd2f',
    red = '#cc241d',
    violet = '#b16286',
    white = '#ebdbb2',
    yellow = '#d79921',
}

vim.g.color_molokai = {
    fg = '#928374',
    -- bg = '#1F2223',
    bg = '#000000',
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
}

vim.g.color_default = {
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
}

if vim.g.custom.theme == 'zellner' then
	vim.cmd([[hi FloatBorder guibg='none']])
	vim.cmd([[hi NormalFloat guibg='none']])
	vim.cmd([[hi StatusLine guibg='#ebdbb2' guifg='#000000']])
end

-- return as molokai when another lua calle
local M = vim.g.color_default
return M
