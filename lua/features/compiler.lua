local delim = vim.fn.has('win32') == 1 and '\\' or '/'
local common = require("features.common")
local display_title = common.DisplayTitle
local group_selection = common.GroupSelection
local compiler_data_dir = vim.fn.stdpath('data') .. delim .. 'compilers'

--define compiler data
--@field name string tittle of build
--@field cmd string command to run
--@field desc string description of build
--@field ext string file extension
--@field build_type string build type: "make", "term", "term_full", "plugin"
--@field group string group name
vim.g.compiler_data = {}
local compiler_build_data = {}
local compiler_latest_build_data = {}

-- compiler selection
-- @param extension file extension
-- @param .name tittle of build (string)
-- @param .cmd command to run (stirng)
-- @param .desc description of build (string)
-- @param .ext file extension (string)
-- @param .type build type: "make", "term", "term_full" (string)
local function compiler_insert_info(name, cmd, desc, ext, type, grp, efm)
	local data = compiler_build_data
	local info = {
		name = name,
		cmd = cmd,
		desc = desc,
		ext = ext,
		build_type = type,
		group = grp,
		efm = efm,
	}

	table.insert(data, info)
	compiler_build_data = data
end

local function compiler_insert_info_permanent(name, cmd, desc, ext, type, grp, efm, opts)
	local data = vim.g.compiler_data
	local info = {
		name = name,
		cmd = cmd,
		desc = desc,
		ext = ext,
		build_type = type,
		group = grp,
		efm = efm,
		opts = opts,
	}

	table.insert(data, info)
	vim.g.compiler_data = data
end

local function compiler_read_json()
	local function check_git_remote_url_exists(remote, str)
		local name = (type(str) == "table") and str or {str}

		for _, n in pairs(name) do
			local url = require('features.git').Remote().GetUrl(remote)

			if url == nil or vim.fn.len(url) == 0 then
				break
			end

			for w in string.gmatch(url, n) do
				if w == n  then
					return true
				end
			end
		end

		return false
	end

	if vim.fn.isdirectory(compiler_data_dir) == 0 then
		return
	end

	local compiler_data_files = require('features.files').RecurSearch(compiler_data_dir, ".json")
	local compiler_data = {}

	for _, f in ipairs(compiler_data_files) do
		local info = require('features.system').GetJsonFile(f)

		if info == nil then
			goto continue
		end

		table.insert(compiler_data, info)
		::continue::
	end

	for _, grp in pairs(compiler_data) do
		for grp_name, grp_info in pairs(grp) do
			for _, i in pairs(grp_info) do
				if i["git"] ~= nil and i["git"]["remote"] ~= nil and i["git"]["url"] ~= nil then
					if check_git_remote_url_exists(i["git"]["remote"], i["git"]["url"]) == false then
						goto skip_current_compiler_setup
					end
				end
				compiler_insert_info_permanent(i.name, i.cmd, i.desc, i.ext, i.type, grp_name, i.efm, i.opts)
				::skip_current_compiler_setup::
			end
		end
	end
end

local function setup_c()
	compiler_insert_info("gcc build", [[gcc % -o %:t:r ]], "gcc build c source", "c", "make", "build")
	compiler_insert_info("gcc run", [[./%:t:r]], "gcc run executable source", "c", "make", "build")
	compiler_insert_info("gcc build & run",
		[[gcc % -o %:t:r && ./%:t:r && rm %:t:r]],
		"gcc build and run c source", "c", "make", "build")
end

local function setup_markdown()
	if io.open(string.lower('book.toml')) then
		local cmd

		if vim.fn.executable('xdg-open') == 2 then
			cmd = 'xdg-open'
		elseif vim.fn.executable('wslview') == 1 then
			cmd = 'wslview'
		elseif vim.fn.executable('open') == 1 then
			cmd = 'open'
		else
			return nil
		end

		cmd = "if [[ ! -d book ]];then mdbook build;fi;"
			.. cmd
			.. " http://localhost:3000 && mdbook serve"

		compiler_insert_info("mdbook", cmd,
			"open mdbook for markdown", "markdown", "make", "build")
	end
end

local function setup_rust()
	if vim.fn.executable('rustc') == 0 then
		return
	end

	compiler_insert_info("build rust", "rustc % --out-dir %:h ",
		"build current rust file", "rust", "make", "build")
	compiler_insert_info("run rust", "./" .. vim.fn.expand("%:r"),
		"run current executable rust file", "rust", "make", "build")

	if io.open(string.lower('Cargo.toml')) then
		compiler_insert_info("cargo build", [[cargo build]],
			"build with cargo", "rust", "make", "build")
		compiler_insert_info("cargo run", [[cargo run]],
			"run with cargo", "rust", "make", "build")
	end
end

local function get_compiler_build_data()
	local function check_current_filetype(ext)
		if vim.bo.filetype == tostring(ext) then
			return true
		end

		return false
	end

	compiler_build_data = {}

	if check_current_filetype("c") then
		setup_c()
	elseif check_current_filetype("markdown") then
		setup_markdown()
	elseif check_current_filetype("python") then
		compiler_insert_info("run script", "python3 %" .. ";read;exit",
			"run current python file", "python", "make", "build")
	elseif check_current_filetype("sh") then
		compiler_insert_info("run script", [[./%]],
			"run current buffer bash script", "sh",  "make", "build")
	elseif check_current_filetype("perl") then
		compiler_insert_info("run script", [[perl %]],
			"run current buffer perl script", "perl", "make", "build")
	elseif check_current_filetype("rs") then
		setup_rust()
	end

	if vim.fn.empty(vim.g.compiler_data) == 0 then
		for _, info in ipairs(vim.g.compiler_data) do
			table.insert(compiler_build_data, info)
		end
	end

	table.sort(compiler_build_data, function(a, b)
		return a.name > b.name
	end)

	return compiler_build_data
end

local function compiler_setup_makeprg(tbl)
	if tbl == nil then
		return false
	end

	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_option(bufnr, 'makeprg', tbl.cmd)

	if tbl.efm ~= nil
	then
		vim.api.nvim_buf_set_option(bufnr, 'errorformat', tbl.efm)
	end

	compiler_latest_build_data = tbl

	return true
end

local function compiler_latest_makeprg_setup()
	if compiler_latest_build_data == nil
	then
		return nil
	end

	local info = compiler_latest_build_data

	if (info.ext ~= 'any') and (info.ext ~= vim.bo.filetype) then
		return false
	end

	return compiler_setup_makeprg(info)
end

local function compiler_tbl_makeprg_setup(tbl)
	local function optional_setup()
		if tbl.opts.callback == nil or tbl.opts.dofile == nil then
			return nil
		end

		local callback_file = compiler_data_dir .. delim .. tbl.opts.dofile

		if vim.fn.filereadable(callback_file) == 0 then
			return nil
		end

		local callback = tbl.opts.callback
		dofile(callback_file)

		if type(callback) == "string" then
			callback = _G[callback]
		end

		if type(callback) == "function" then
			return callback()
		end

		return nil
	end

	if tbl == nil then
		return false
	end

	if tbl.opts ~= nil then
		if optional_setup() == false then
			vim.api.nvim_echo({{"compiler callback error", "ErrorMsg"}}, true, {})
			return false
		end
	end

	if tbl.build_type == "term" then
		vim.cmd("5split | terminal " .. tbl.cmd)
		return false
	end

	if tbl.build_type == "term_full" then
		if vim.fn.exists(":ToggleTerm") and vim.fn.exists(":TermCmd")
		then
			vim.cmd("TermCmd " .. tbl.cmd)
		else
			vim.cmd("tabnew | terminal " .. tbl.cmd)
		end

		return false
	end

	if tbl.build_type == "builtin" then
		vim.cmd(tbl.cmd)
		return false
	end

	return compiler_setup_makeprg(tbl)
end

local function compiler_build_setup_selection()
	local tbl = get_compiler_build_data()

	if tbl == nil then
		return false
	end

	local grp = group_selection(tbl)

	if grp == nil then
		return false
	end

	local target_tbl = {}
	local msg = {}
	local idx = 0

	for _, info in ipairs(tbl) do
		if (info.ext ~= 'any') and (info.ext ~= vim.bo.filetype) then
			goto continue
		end

		if (info.group ~= grp) then
			goto continue
		end

		idx = idx + 1

		msg[idx] = string.format(
			"%3d | %-20s | %5s\t", idx, info.name, info.desc
		)

		table.insert(target_tbl, info)

		::continue::
	end

	if #target_tbl == 0 then
		return false
	end

	display_title(string.format(
		"%3s | %-20s | %-s", "idx",  "name", "description")
	)

	local sel_idx = vim.fn.inputlist(msg)
	local sel_tbl = target_tbl[sel_idx]

	if sel_tbl == nil then
		return false
	end

	return compiler_tbl_makeprg_setup(sel_tbl)
end

local function setup()
	compiler_read_json()

	return nil
end

return {
	Setup = setup,
	Selection = compiler_build_setup_selection,
	LastSelect = compiler_latest_makeprg_setup,
	InsertInfo = compiler_insert_info_permanent,
}
