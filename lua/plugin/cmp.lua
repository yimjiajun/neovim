local function python_setup()
    local on_attach = function(client, _)
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end
    -- Configure `ruff-lsp`.
    -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
    -- For the default config, along with instructions on how to customize the settings
    require("lspconfig").ruff.setup({
        on_attach = on_attach,
        init_options = {
            settings = {
                -- Any extra CLI arguments for `ruff` go here.
                args = { "format --check", "check" },
            },
        },
    })
    require("lspconfig").pyright.setup({
        settings = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { "*" },
                },
            },
        },
    })
end

local function setup()
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    local servers = vim.g.custom.lsp
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({ capabilities = capabilities })
    end

    lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_dir = lspconfig.util.root_pattern(
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
            ".git"
        ),
        single_file = true,
        init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
        },
        on_attach = function() end,
    })

    -- luasnip setup
    local luasnip = require("luasnip")

    -- nvim-cmp setup
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<C-n>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }),
    })

    python_setup()
end

return { Setup = setup }
