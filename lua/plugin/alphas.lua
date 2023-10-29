local if_nil = vim.F.if_nil

local default_terminal = {
	type = "terminal",
	command = nil,
	width = 69,
	height = 8,
	opts = {
		redraw = true,
		window_config = {},
	},
}

local hour = tonumber(os.date("%H"))
local day = tonumber(os.date("%w"))
local month = tonumber(os.date("%m"))
local year = tonumber(os.date("%Y"))
local display
local msg_display

if day <= 5 then
	if hour > 9 and hour < 17 then
		display = "work"
	else
		display = "home"
	end
else
	if hour > 22 or hour < 6 then
		display = "sleep"
	else
		display = "free"
	end
end

if display == "work" then
	if year == 2023 then
		if month < 12 and month >= 5 then
			display = "work on mstf"
		end
	end
end

if display == "work" then
	msg_display = {
		[[ ]],
		[[ ]],
		[[     ███████╗  ███╗   ███╗ ██╗            ███████╗  ██████╗]],
		[[     ╚═════██╗ ████╗ ████║ ██║            ██╔════╝ ██╔════╝]],
		[[     ████████║ ██╔████╔██║ ██║ █████████╗ █████╗   ██║]],
		[[     ██║   ██║ ██║╚██╔╝██║ ██║ ╚════════╝ ██╔══╝   ██║]],
		[[     ╚██████╔╝ ██║ ╚═╝ ██║ ██║            ███████╗ ╚██████╗]],
		[[      ╚═════╝  ╚═╝     ╚═╝ ╚═╝            ╚══════╝  ╚═════╝]],
		[[                             ██═╗   ██╗]],
		[[                              ██╚╗██╔═╝]],
		[[                               ████╔╝]],
		[[                              ██╔═██═╗]],
		[[                             ██╔╝  ╚██╗]],
		[[                             ╚═╝    ╚═╝]],
		[[ ███████╗  ██╗  ██████╗ ██╗     ██╗  ██████╗  ███████╗  ███████╗]],
		[[ ██╔═══██╗ ██║ ██╔════╝ ██║     ██║ ██╔═══██╗ ██╔═══██╗ ██╔═══██╗]],
		[[ ████████║ ██║ ██║      ██████████║ ████████║ ████████║ ██║   ██║]],
		[[ ██╔═██╔═╝ ██║ ██║      ██╔═════██║ ██╔═══██║ ██╔═██╔═╝ ██║   ██║]],
		[[ ██║ ████╗ ██║ ╚██████╗ ██║     ██║ ██║   ██║ ██║ ████╗ ███████╔╝]],
		[[ ╚═╝ ╚═══╝ ╚═╝  ╚═════╝ ╚═╝     ╚═╝ ╚═╝   ╚═╝ ╚═╝ ╚═══╝ ╚══════╝]],
	}
elseif display == "work on mstf" then
	msg_display = {
		[[ ]],
		[[┌╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓╓  ╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╥╕]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌]],
		[[└╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙  ╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙']],
		[[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[]],
		[[╞▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑ╡]],
	}
elseif display == "home" then
	msg_display = {
		[[ ]],
		[[ ]],
		[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
		[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
		[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
		[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
		[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
		[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
		[[                   ██═╗   ██╗]],
		[[                    ██╚╗██╔═╝]],
		[[                     ████╔╝]],
		[[                    ██╔═██═╗]],
		[[                   ██╔╝  ╚██╗]],
		[[                   ╚═╝    ╚═╝]],
		[[      ██╗██╗ █████╗           ██╗██╗   ██╗███╗   ██╗]],
		[[      ██║██║██╔══██╗          ██║██║   ██║████╗  ██║]],
		[[      ██║██║███████║          ██║██║   ██║██╔██╗ ██║]],
		[[ ██   ██║██║██╔══██║     ██   ██║██║   ██║██║╚██╗██║]],
		[[ ╚█████╔╝██║██║  ██║     ╚█████╔╝╚██████╔╝██║ ╚████║]],
		[[ ╚════╝ ╚═╝╚═╝  ╚═╝      ╚════╝  ╚═════╝ ╚═╝  ╚═══╝]],
	}
elseif display == "sleep" then
	msg_display = {
		[[ ]],
		[[ ]],
		[[███████╗██╗     ███████╗███████╗██████╗           ]],
		[[██╔════╝██║     ██╔════╝██╔════╝██╔══██╗          ]],
		[[███████╗██║     █████╗  █████╗  ██████╔╝          ]],
		[[╚════██║██║     ██╔══╝  ██╔══╝  ██╔═══╝           ]],
		[[███████║███████╗███████╗███████╗██║      ██╗██╗██╗]],
		[[╚══════╝╚══════╝╚══════╝╚══════╝╚═╝      ╚═╝╚═╝╚═╝]],
	}
else
	msg_display = {
		[[ ]],
		[[ ]],
		[[|  \    /  \      \  \     /  \       |     \      \/      \        |     \  \  |  \  \  |  \]],
		[[ \▓▓\  /  ▓▓\▓▓▓▓▓▓ ▓▓\   /  ▓▓        \▓▓▓▓▓\▓▓▓▓▓▓  ▓▓▓▓▓▓\        \▓▓▓▓▓ ▓▓  | ▓▓ ▓▓\ | ▓▓]],
		[[  \▓▓\/  ▓▓  | ▓▓ | ▓▓▓\ /  ▓▓▓          | ▓▓ | ▓▓ | ▓▓__| ▓▓          | ▓▓ ▓▓  | ▓▓ ▓▓▓\| ▓▓]],
		[[   \▓▓  ▓▓   | ▓▓ | ▓▓▓▓\  ▓▓▓▓     __   | ▓▓ | ▓▓ | ▓▓    ▓▓     __   | ▓▓ ▓▓  | ▓▓ ▓▓▓▓\ ▓▓]],
		[[    \▓▓▓▓    | ▓▓ | ▓▓\▓▓ ▓▓ ▓▓    |  \  | ▓▓ | ▓▓ | ▓▓▓▓▓▓▓▓    |  \  | ▓▓ ▓▓  | ▓▓ ▓▓\▓▓ ▓▓]],
		[[    | ▓▓    _| ▓▓_| ▓▓ \▓▓▓| ▓▓    | ▓▓__| ▓▓_| ▓▓_| ▓▓  | ▓▓    | ▓▓__| ▓▓ ▓▓__/ ▓▓ ▓▓ \▓▓▓▓]],
		[[    | ▓▓   |   ▓▓ \ ▓▓  \▓ | ▓▓     \▓▓    ▓▓   ▓▓ \ ▓▓  | ▓▓     \▓▓    ▓▓\▓▓    ▓▓ ▓▓  \▓▓▓]],
		[[     \▓▓    \▓▓▓▓▓▓\▓▓      \▓▓      \▓▓▓▓▓▓ \▓▓▓▓▓▓\▓▓   \▓▓      \▓▓▓▓▓▓  \▓▓▓▓▓▓ \▓▓   \▓▓]],
		[[ ]],
		[[ ]],
	}
end

local default_header = {
	type = "text",
	val = msg_display,
	opts = {
		position = "center",
		hl = "String",
		-- wrap = "overflow";
	},
}

local footer = {
	type = "text",
	val = "",
	opts = {
		position = "center",
		hl = "Number",
	},
}

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "center",
		shortcut = sc,
		cursor = 5,
		width = 50,
		align_shortcut = "right",
		hl_shortcut = "Keyword",
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "tx", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

local buttons = {
	type = "group",
	val = {
		button("+", "  Configuration", "<cmd> e ~/.config/nvim/init.lua  <CR>"),
		button("0", "  Recently opened files", "<cmd> lua require('telescope.builtin').oldfiles()<CR>"),
		button("1", "  Sessions", [[<cmd> lua require('config.function').SelSession() <CR>]]),
		button("2", "󰥨  Find file", [[<cmd> lua require('config.function').SearchFile("") <CR>]]),
		button("3", "󱙓  Find word",  [[<cmd> lua require('config.function').SearchWord("") <CR>]]),
		button("4", "  Jump to bookmarks", [[<cmd> lua require('config.function').GetMarks("default") <CR>]]),
		button("5", "󰍒  Frecency/MRU", [[<cmd> lua require('config.function').GetJumplist("default") <CR>]]),
		button("6", "󱖫  Git Status",  [[<cmd>lua require('config.function').GitLog("") <CR>]]),
		button("7", "  Git logs", [[<cmd> lua require('config.function').GitStatus("") <CR>]]),
		button("8", "  Create ctags", [[<cmd> lua require('config.function').CreateCtags() <CR>]]),
		button("c", "  Calendar", [[<cmd> lua require('features.system').GetCalendar() <CR>]]),
		button("b", "  Battery", [[<cmd> lua require('features.system').GetBatInfo() <CR>]]),
		button("SPC v s T", "  View process system"),
	},
	opts = {
		spacing = 1,
	},
}

local section = {
	terminal = default_terminal,
	header = default_header,
	buttons = buttons,
	footer = footer,
}

local config = {
	layout = {
		{ type = "padding", val = 2 },
		section.header,
		{ type = "padding", val = 2 },
		section.buttons,
		section.footer,
	},
	opts = {
		margin = 5,
	},
}

return {
	button = button,
	section = section,
	config = config,
	-- theme config
	leader = leader,
	-- deprecated
	opts = config,
}
