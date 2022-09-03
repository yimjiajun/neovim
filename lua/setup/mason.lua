require("mason").setup()

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = { "bashls", "clangd", "cmake",
		"sumneko_lua", "zk", "ltex", "yamlls",
		"powershell_es", "pyright"}
})
