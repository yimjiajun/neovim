local sys_func = require("features.system")
local compiler_build_data = {}

-- compiler selection
-- @param extension file extension
-- @param .name tittle of build (string)
-- @param .cmd command to run (stirng)
-- @param .desc description of build (string)
-- @param .ext file extension (string)
-- @param .type build type: "make", "term", "term_full" (string)
local function compiler_insert_info(name, cmd, desc, ext, type)
	local data = compiler_build_data
	local info = {
		name = name,
		cmd = cmd,
		desc = desc,
		build_type = type,
		ext = ext,
	}

	table.insert(data, info)
	compiler_build_data = data
end

local function setup_c()
	local function setup_zephyr_project()
		if vim.fn.executable('west') == 0 then
			return
		end

		local cmd = "if [[ $(west config --local -l | grep -c 'manifest.path') -eq 0 ]] then;"
					.. "echo -n 'Enter zephyr base directory: '; read; cd $REPLY; west init -l;"
				.. "fi;"

		cmd = cmd .. "if [[ $((west config --local -l) | grep -c 'zephyr.base-prefer') -eq 0 ]] then;"
					.. "west config --local zephyr.base-prefer configfile;"
					.. "echo -n 'Enter project directory: '; read; west config --local zephyr.base $REPLY;"
					.. "echo -n 'Enter board name: ' ; read; west conifg --local build.board $REPLY;"
				.. "fi;"

		compiler_insert_info("zephyr setup",
			cmd .. "exit",
			"setup ecfw-zephyr configuration", "c", "term")
		compiler_insert_info("zephyr build",
			"west build -d $(west config manifest.path)/build $(west config manifest.path);" .. "exit",
			"build zephyr project", "c", "make")
		compiler_insert_info("zephyr build all",
			"west build -p=always -d $(west config manifest.path)/build $(west config manifest.path);" .. "exit",
			"re-build zephyr project as pristine", "c", "make")
		compiler_insert_info("zephyr menu",
			"west build -t menuconfig $(west config manifest.path);" .. "exit",
			"interactive config zephyr kconfig value", "c", "term_full")
	end

	setup_zephyr_project()

	compiler_insert_info("gcc build", [[gcc % -o %:t:r ]], "gcc build c source", "make")
	compiler_insert_info("gcc run", [[./%:t:r]], "gcc run executable source", "make")
	compiler_insert_info("gcc build & run",
		[[gcc % -o %:t:r && mv %:t:r /tmp/%:t:r && /tmp/%:t:r && rm /tmp/%:t:r]],
		"gcc build and run c source", "make")
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
			"open mdbook for markdown", "markdown", "make")
	end

	if vim.fn.exists('g:mkdp_command_for_global') == 1 then
		compiler_insert_info("md preview", [[nvim +MarkdownPreview %]],
			"Preview current markdown file", "markdown", "make")
	end
end

local function setup_rust()
	if vim.fn.executable('rustc') == 0 then
		return
	end

	compiler_insert_info("build rust", "rustc % --out-dir %:h ",
		"build current rust file", "rust", "make")
	compiler_insert_info("run rust", "./" .. vim.fn.expand("%:r"),
		"run current executable rust file", "rust", "make")

	if io.open(string.lower('Cargo.toml')) then
		compiler_insert_info("cargo build", [[cargo build]],
			"build with cargo", "rust", "make")
		compiler_insert_info("cargo run", [[cargo run]],
			"run with cargo", "rust", "make")
	end
end

local function get_compiler_build_data()

	compiler_build_data = { }
	local check_ext_file_exist = sys_func.ChkExtExist

	if check_ext_file_exist("c") == 1 then
		setup_c()
	end

	if check_ext_file_exist("md") == 1 then
		setup_markdown()
	end

	if check_ext_file_exist("py") == 1 then
		compiler_insert_info("run script", "python3 %" .. ";read;exit",
			"run current python file", "py", "make")
	end

	if check_ext_file_exist("sh") == 1 then
		compiler_insert_info("run script", [[./%]],
			"run current buffer bash script", "sh",  "make")
	end

	if check_ext_file_exist("perl") == 1 then
		compiler_insert_info("run script", [[perl %]],
			"run current buffer perl script", "perl", "make")
	end

	if check_ext_file_exist("rs") == 1 then
		setup_rust()
	end

	if vim.fn.empty(vim.g.compiler_build_data) == 0 then
		table.insert(compiler_build_data, vim.g.compiler_build_data)
	end

	return compiler_build_data
end

local function compiler_build_selection()

	local tbl = get_compiler_build_data()
	local target_tbl = {}
	local target_tbl_cnt = 0
	local display_msg = string.format("%3s| %-20s | %-s", "idx",  "name", "description")
	print("---------------list of compilers---------------+")
	print(display_msg)
	print("------------------------------------------------+")

	for idx, info in ipairs(tbl) do
		if (info.ext == vim.bo.filetype) then
			target_tbl_cnt = target_tbl_cnt + 1
			display_msg = string.format("%3d| %-20s | %5s\t", target_tbl_cnt, info.name, info.desc)
			vim.api.nvim_echo({{display_msg, "none"}}, true, {})
			table.insert(target_tbl, info)
		end
	end

	print("---------------end of list----------------------+")
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

	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_option(bufnr, 'makeprg', sel_tbl.cmd)

	return true
end


local ret = {
	Selection = compiler_build_selection,
}

return ret
