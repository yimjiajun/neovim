local sys_func = require("features.system")
local common = require("features.common")
local display_tittle = common.DisplayTittle
local display_delimited_line = common.DisplayDelimitedLine
local group_selection = common.GroupSelection

--define compiler data
--@field name string tittle of build
--@field cmd string command to run
--@field desc string description of build
--@field ext string file extension
--@field build_type string build type: "make", "term", "term_full", "plugin"
--@field group string group name
vim.g.compiler_data = {}
local compiler_build_data = {}

-- compiler selection
-- @param extension file extension
-- @param .name tittle of build (string)
-- @param .cmd command to run (stirng)
-- @param .desc description of build (string)
-- @param .ext file extension (string)
-- @param .type build type: "make", "term", "term_full" (string)
local function compiler_insert_info(name, cmd, desc, ext, type, grp)
	local data = compiler_build_data
	local info = {
		name = name,
		cmd = cmd,
		desc = desc,
		ext = ext,
		build_type = type,
		group = grp,
	}

	table.insert(data, info)
	compiler_build_data = data
end

local function compiler_insert_info_permanent(name, cmd, desc, ext, type, grp)
	local data = vim.g.compiler_data
	local info = {
		name = name,
		cmd = cmd,
		desc = desc,
		ext = ext,
		build_type = type,
		group = grp,
	}

	table.insert(data, info)
	vim.g.compiler_data = data
end

local function setup_c()
	compiler_insert_info("gcc build", [[gcc % -o %:t:r ]], "gcc build c source", "c", "make", "build")
	compiler_insert_info("gcc run", [[./%:t:r]], "gcc run executable source", "c", "make", "build")
	compiler_insert_info("gcc build & run",
		[[gcc % -o %:t:r && mv %:t:r /tmp/%:t:r && /tmp/%:t:r && rm /tmp/%:t:r]],
		"gcc build and run c source", "c", "make", "build")
end

local function setup_markdown()
	if io.open(string.lower('book.toml')) then
		local cmd = nil

		if vim.fn.executable('xdg-open') == 1 then
			cmd = 'xdg-open'
		elseif vim.fn.executable('wslview') == 1 then
			cmd = 'wslview'
		elseif vim.fn.executable('open') == 1 then
			cmd = 'open'
		else
			return nil
		end

		cmd = "if [[ ! -d book ]];then; mdbook build;fi;"
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
		if vim.bo.filetype == ext then
			return true
		end

		return false
	end

	compiler_build_data = {}

	if check_current_filetype("c") then
		setup_c()
	end

	if check_current_filetype("md") then
		setup_markdown()
	end

	if check_current_filetype("py") then
		compiler_insert_info("run script", "python3 %" .. ";read;exit",
			"run current python file", "py", "make", "build")
	end

	if check_current_filetype("sh") then
		compiler_insert_info("run script", [[./%]],
			"run current buffer bash script", "sh",  "make", "build")
	end

	if check_current_filetype("perl") then
		compiler_insert_info("run script", [[perl %]],
			"run current buffer perl script", "perl", "make", "build")
	end

	if check_current_filetype("rs") then
		setup_rust()
	end

	if vim.fn.empty(vim.g.compiler_data) == 0 then
		for _, info in ipairs(vim.g.compiler_data) do
			table.insert(compiler_build_data, info)
		end
	end

	return compiler_build_data
end

local function compiler_build_selection()
	local tbl = get_compiler_build_data()

	if tbl == nil then
		return false
	end

	local grp = group_selection(tbl)

	if grp == nil then
		return false
	end

	local target_tbl = {}
	local target_tbl_cnt = 0
	local display_msg = string.format("%3s| %-20s | %-s", "idx",  "name", "description")
	display_tittle(display_msg)

	for _, info in ipairs(tbl) do
		if (info.ext ~= 'any') and (info.ext ~= vim.bo.filetype) then
			goto continue
		end

		if (info.group ~= grp) then
			goto continue
		end

		target_tbl_cnt = target_tbl_cnt + 1
		display_msg = string.format("%3d| %-20s | %5s\t", target_tbl_cnt, info.name, info.desc)
		vim.api.nvim_echo({{display_msg, "none"}}, true, {})
		table.insert(target_tbl, info)

		 if target_tbl_cnt % 2 == 0 then
			 if target_tbl_cnt % 4 == 0 then
				 display_delimited_line("~")
			 else
				 display_delimited_line("-")
			 end
		 end

		::continue::
	end

	local sel_idx = tonumber(vim.fn.input("Enter number to run build: "))

	if sel_idx == nil then
		return false
	end

	local sel_tbl = target_tbl[sel_idx]

	if sel_tbl == nil then
		vim.api.nvim_echo({{"\nInvalid index", "WarningMsg"}}, true, {})
		return false
	end

	if sel_tbl.build_type == "term" then
		vim.cmd("5split | terminal " .. sel_tbl.cmd)
		return false
	end

	if sel_tbl.build_type == "term_full" then
		if vim.fn.exists(":ToggleTerm") and vim.fn.exists(":TermCmd") then
			vim.cmd("TermCmd " .. sel_tbl.cmd)
		end

		vim.cmd("tabnew | terminal " .. sel_tbl.cmd)
		return false
	end

	if sel_tbl.build_type == "builtin" then
		vim.cmd(sel_tbl.cmd)
		return false
	end

	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_option(bufnr, 'makeprg', sel_tbl.cmd)

	return true
end


local ret = {
	Selection = compiler_build_selection,
	InsertInfo = compiler_insert_info_permanent,
}

return ret
