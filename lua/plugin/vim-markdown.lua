local function setup_vim_markdown()
    vim.opt.conceallevel = 2
    vim.g.vim_markdown_new_list_item_indent = 2
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_folding_level = 1
    vim.g.vim_markdown_folding_style_pythonic = 1
    vim.g.vim_markdown_override_foldtext = 1
    vim.g.vim_markdown_follow_anchor = 1
    vim.g.vim_markdown_toc_autofit = 1
    vim.g.vim_markdown_fenced_languages = {
        "bash=sh", "c", "cpp", "css", "dockerfile", "html", "java",
        "javascript", "js=javascript", "json", "lua", "python", "sh", "vim",
        "yaml"
    }
end

local function setup()
    setup_vim_markdown()
end

return { Setup = setup }
