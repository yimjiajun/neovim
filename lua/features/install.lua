local function install_rust()
	if vim.fn.executable('cargo') == 1 then
		return
	end

	local install_script = [[ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ]]
	local rust_env = "$HOME/.cargo/env"
	local shell = vim.fn.trim(vim.fn.tolower(vim.fn.system("echo $SHELL")))
	local shell_src = vim.fn.system("echo " .. "$HOME/." .. vim.fn.fnamemodify(shell, ":t") .. "rc")
	local rust_env_setup = tonumber(vim.fn.system("grep -c 'source " .. rust_env .. "' " .. shell_src))
	vim.fn.execute("tabnew | term " .. install_script .. "; exit")

	if rust_env_setup == 0 then
		vim.fn.system("echo 'source " .. rust_env .. "' >> " .. shell_src)
		vim.api.nvim_echo({{"Export rust env to " .. shell_src, "MoreMsg"}}, true, {})
		vim.fn.system("source " .. shell_src)
	end
end

local function install_mdbook()
	if vim.fn.executable('cargo') == 0 then
		install_rust()
	end

	if vim.fn.executable('mdbook') == 0 then
		local install_script = [[cargo install --git https://github.com/rust-lang/mdBook.git mdbook]]
		vim.api.nvim_echo({{"Installing mdbook...", "MoreMsg"}}, true, {})
		-- vim.cmd("tagnew | term " .. install_script .. "; exit")
		print(vim.fn.system(install_script))
	end

	if vim.fn.executable('mdbook-pdf') == 0 and vim.fn.executable('pip3') == 1 then
		vim.api.nvim_echo({{"Installing mdbook-pdf...", "MoreMsg"}}, true, {})
		-- vim.cmd("tabnew | term pip3 install mdbook-pdf-outline; exit")
		print(vim.fn.system("pip3 install mdbook-pdf-outline"))
	end

	if vim.fn.executable("mdbook-mermaid") == 0 then
		vim.api.nvim_echo({{"Installing mdbook-mermaid...", "MoreMsg"}}, true, {})
		-- vim.cmd("tabnew | term cargo install mdbook-mermaid; exit")
		print(vim.fn.system("cargo install mdbook-mermaid"))
	end
end

local function install_all()
	install_rust()
	install_mdbook()
end

local ret = {
	Rust = install_rust,
	Mdbook = install_mdbook,
	All = install_all,
}

vim.cmd("command! -nargs=0 InstallAll lua require('features.install').All()")

return ret
