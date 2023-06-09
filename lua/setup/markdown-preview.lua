local function setup_browser()
	if vim.fn.has("mac") == 1 then
		vim.g.mkdp_browser = 'safari'
		return
	end

	if vim.fn.has("win32") == 1 then
		vim.g.mkdp_browser = 'MicrosoftEdge.exe'
		return
	end

	if vim.fn.has("unix") == 1 then
		if vim.fn.isdirectory("/run/WSL") == 1 then
			vim.g.mkdp_browser = 'MicrosoftEdge.exe'
			return
		end

		if vim.fn.executable("google-chrome") == 1 then
			vim.g.mkdp_browser = 'google-chrome'
			return
		end

		if vim.fn.executable("firefox") == 1 then
			vim.g.mkdp_browser = 'firefox'
			return
		end
	end
end

local function setup_builtin_compiler()
	local md_compiler_data = {
		name = "markdown (browser)",
		cmd = "MarkdownPreview",
		desc = "preview current buffer markdown on browser",
		ext = "markdown",
		build_type = "builtin",
		group = "plugin",
	}

	require('features.compiler').InsertInfo(
		md_compiler_data.name,
		md_compiler_data.cmd,
		md_compiler_data.desc,
		md_compiler_data.ext,
		md_compiler_data.build_type,
		md_compiler_data.group
	)

	if pcall(require, 'glow') then
		md_compiler_data = {
			name = "markdown (neovim)",
			cmd = "Glow",
			desc = "preview current buffer markdown in neovim",
			ext = "markdown",
			build_type = "builtin",
			group = "plugin",
		}

		require('features.compiler').InsertInfo(
			md_compiler_data.name,
			md_compiler_data.cmd,
			md_compiler_data.desc,
			md_compiler_data.ext,
			md_compiler_data.build_type,
			md_compiler_data.group
		)
	end
end

vim.g.mkdp_filetypes = { "markdown" }
vim.g.browser = nil
setup_browser()
setup_builtin_compiler()

return nil
