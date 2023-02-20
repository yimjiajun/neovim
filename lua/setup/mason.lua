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
		"lua_ls", "zk", "ltex", "yamlls",
		"pyright"}
})
