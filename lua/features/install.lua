local function install_rust()
	if vim.fn.executable('rustc') == 0 then
		return
	end

	local install_script = [[ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ]]
	local rust_env = "$HOME/.cargo/env"
	local shell = vim.fn.trim(vim.fn.tolower(vim.fn.system("echo $SHELL")))
	local shell_src = vim.fn.system("echo " .. "$HOME/." .. vim.fn.fnamemodify(shell, ":t") .. "rc")
	local rust_env_setup = tonumber(vim.fn.system("grep -c 'source " .. rust_env .. "' " .. shell_src))
	vim.fn.execute("term " .. install_script .. "; exit")

	if rust_env_setup == 0 then
		vim.fn.system("echo 'source " .. rust_env .. "' >> " .. shell_src)
		vim.api.nvim_echo({{"Export rust env to " .. shell_src, "MoreMsg"}}, true, {})
	end
end

local ret = {
	Rust = install_rust,
}

return ret
