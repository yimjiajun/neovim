local install_pkgs = {
    "c", "cpp", "cmake", "bash", "lua", "perl", "make", "markdown",
    "markdown_inline", "python", "yaml", "vim", "vimdoc"
}

local function setup()
    require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all"
        ensure_installed = install_pkgs,
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = { "javascript" },

        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            disable = function(_lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
            end
        },
        indent = { enable = true }
    }
end

return { Setup = setup }
