local function setup()
    local function setup_keymap()
        vim.keymap.set("v", "<leader>lf", vim.lsp.buf.format, { remap = false })

        if pcall(require, 'which-key') then
            local wk = require("which-key")
            wk.add({
                mode = { "n" },
                { "gD", desc = "lsp declartion" },
                { "gd", desc = "lsp definition" },
                { "gi", desc = "lsp implementation" },
                { "gr", desc = "lsp references" },
                { "gt", desc = "type definition" },
                { "<leader>l", group = "Lsp" },
                { "<leader>lQ", desc = "diagnostic lists" },
                { "<leader>lc", desc = "code action" },
                { "<leader>lf", desc = "formatting" },
                { "<leader>lq", desc = "diagnostic float" },
                { "<leader>lr", desc = "rename" },
                { "<leader>lw", group = "Worksapce" },
                { "<leader>lwa", desc = "add folder" },
                { "<leader>lwl", desc = "list folder" },
                { "<leader>lwr", desc = "remove folder" },
            })
            wk.add({
                mode = { "v" },
                { "<leader>l", group = "Lsp" },
                { "<leader>lc", desc = "code action" },
                { "<leader>lf", desc = "formatting" },
            })
        end
    end
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>lq', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>lQ', vim.diagnostic.setloclist)
    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>lwl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>lc', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<space>lf', function()
                vim.lsp.buf.format { async = true }
            end, opts)
        end
    })

    vim.diagnostic.config({
        signs = true,
        underline = false,
        update_in_insert = false,
        virtual_text = false
    })

    setup_keymap()
end

return { Setup = setup }
