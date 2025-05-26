local function setup()
    local function setup_keymapping()
        vim.keymap.set("n", "<leader>e", function()
            if vim.bo.filetype == "oil" then
                require("oil").close()
                return
            end

            require("oil").open(vim.fn.getcwd())
        end, { silent = true, desc = "file explore" })

        vim.keymap.set("n", "<leader>E", function()
            if vim.bo.filetype == "oil" then
                require("oil").close()
                return
            end

            require("oil").open()
        end, {
            silent = true,
            desc = "file explore (from file directory)",
        })
    end

    require("oil").setup()

    setup_keymapping()
end

return { Setup = setup }
