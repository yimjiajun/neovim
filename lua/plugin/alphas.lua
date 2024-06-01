-- @brief Update the dashboard when the filetype is alpha
-- @description Update the dashboard with the current time, date, and khal
-- every specified time interval
local function update_dashboard()
  if vim.bo.filetype ~= 'alpha' then
    return
  end

  vim.defer_fn(function()
    require('plugin.alphas').Setup()
    vim.cmd("AlphaRedraw")
    update_dashboard()
  end, 250)
end

--@brief Get the ASCII art for the dashboard
--@description Get the ASCII art for the dashboard based on the current time
local function get_display()
  local hour = tonumber(os.date("%H"))
  local day = tonumber(os.date("%w"))
  local month = tonumber(os.date("%m"))
  local year = tonumber(os.date("%Y"))
  local display
  local ascii = {
    ["work"] = {
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
    },
    ["work_on_mstf"] = {
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
    },
    ["home"] = {
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
    },
    ["free"] = {
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
    },
    ["sleep"] = {
      [[ ]],
      [[ ]],
      [[███████╗██╗     ███████╗███████╗██████╗           ]],
      [[██╔════╝██║     ██╔════╝██╔════╝██╔══██╗          ]],
      [[███████╗██║     █████╗  █████╗  ██████╔╝          ]],
      [[╚════██║██║     ██╔══╝  ██╔══╝  ██╔═══╝           ]],
      [[███████║███████╗███████╗███████╗██║      ██╗██╗██╗]],
      [[╚══════╝╚══════╝╚══════╝╚══════╝╚═╝      ╚═╝╚═╝╚═╝]],
    }
  }

  if hour > 8 and hour < 17 then
    display = "work"
  elseif hour > 17 and hour < 22 then
    display = "home"
  else
    display = "sleep"
  end

  if display == "work" and (year == 2023 and month <= 12 and month >= 5) then
    display = "work_on_mstf"
  end

  if day > 5 and display == "work" then
    display = "free"
  end

  return ascii[display]
end

--@brief Setup the alpha plugin
--@description Setup the alpha plugin neccessary settings
local function setup ()
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
  local default_header = {
    type = "text",
    val = get_display(),
    opts = {
      position = "center",
      hl = "Type",
      -- wrap = "overflow";
    },
  }

  local footer_value = os.date("%d %b %Y \t\t %A \t\t %H:%M:%S") .. "\n"

  if vim.fn.executable('khal') == 1 then
    footer_value = footer_value .. "\n \n" ..
    vim.fn.system("khal list now --format '\t{start-time} {end-time} \t {title}'")
  end

  local footer = {
    type = "text",
    val = footer_value,
    opts = {
      position = "center",
      hl = "Define",
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
    val = {},
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

  vim.cmd [[
      autocmd FileType * setlocal laststatus=2 noruler
      autocmd FileType alpha setlocal laststatus=0
      autocmd FileType alpha :AlphaUpdate
  ]]

  local settings = {
    button = button,
    section = section,
    config = config,
    -- theme config
    leader = leader,
    -- deprecated
    opts = config,
  }

  require('alpha').setup(settings.config)
  vim.cmd("command! -nargs=0 AlphaUpdate lua require('plugin.alphas').AlphaUpdate()")
end

return {
  AlphaUpdate = update_dashboard,
  Setup = setup
}
