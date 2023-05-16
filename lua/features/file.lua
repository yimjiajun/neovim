local function pandoc_install()
	local cmd = nil

	if vim.fn.exists('unix') then
		cmd = "sudo apt install -y "
		cmd = cmd ..  " texlive-latex-base " .. " texlive-latex-extra " .. "texlive-xetex "
	end

	if vim.fn.empty(cmd) == 0 then
		vim.cmd("tab term " .. cmd .. "; exit")
	end
end

local function pandoc_convert_to_pdf(file)

	local cmd = "pandoc -s -f markdown-implicit_figures --pdf-engine=xelatex "

	if vim.fn.executable('pandoc') == 0 then
		vim.api.nvim_echo({{"pandoc not installed!", "WarningMsg"}}, true, {})
		vim.api.nvim_echo({{"Install pandoc ...", "MoreMsg"}}, true, {})
		pandoc_install()
	end

	cmd = cmd .. file .. " -o " .. vim.fn.fnamemodify(file, ":t:r") .. ".pdf"

    print(vim.fn.system(cmd))
end

local ret = {
	ConvPdf = pandoc_convert_to_pdf,
	Install = pandoc_install,
}

vim.cmd("command! -nargs=1 ConvPdf lua require('features.file').ConvPdf(<f-args>)")

return ret
