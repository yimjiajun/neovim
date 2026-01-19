vim.g.mkdp_filetypes = { "markdown" }
vim.g.browser = nil

local function setup_browser()
    local info = {
        { os = "mac", browser = "safari" },
        { os = "win32", browser = "MicrosoftEdge.exe" },
        { os = "unix", browser = "firefox" },
        { os = "unix", browser = "google-chrome" },
    }

    for _, v in pairs(info) do
        if vim.fn.has(v.os) == 1 then
            if vim.fn.executable(v.browser) == 1 then
                vim.g.mkdp_browser = v.browser
                return
            end
        end
    end
end

local function setup_builtin_compiler()
    local md_compiler_data = {
        name = "md (browser)",
        cmd = "MarkdownPreview",
        desc = "preview current buffer markdown on browser",
        ext = "markdown",
        build_type = "builtin",
        group = "plugin",
    }

    require("features.compiler").InsertInfo(
        md_compiler_data.name,
        md_compiler_data.cmd,
        md_compiler_data.desc,
        md_compiler_data.ext,
        md_compiler_data.build_type,
        md_compiler_data.group
    )

    if pcall(require, "glow") then
        md_compiler_data = {
            name = "md (neovim)",
            cmd = "Glow",
            desc = "preview current buffer markdown in neovim",
            ext = "markdown",
            build_type = "builtin",
            group = "plugin",
        }

        require("features.compiler").InsertInfo(
            md_compiler_data.name,
            md_compiler_data.cmd,
            md_compiler_data.desc,
            md_compiler_data.ext,
            md_compiler_data.build_type,
            md_compiler_data.group
        )
    end
end

local function setup()
    setup_browser()
    setup_builtin_compiler()
end

return { Setup = setup }
