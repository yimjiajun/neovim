local function pandoc_install()
	local cmd = nil

	cmd = require('features.system').GetInstallPackageCmd()

	if cmd == nil then
		vim.api.nvim_echo({{"Not support this system!", "WarningMsg"}}, true, {})
		return
	end

	cmd = cmd ..  " texlive-latex-base " .. " texlive-latex-extra " .. "texlive-xetex "
	vim.cmd("tabnew | term " .. cmd .. "; exit")
end

local function pandoc_convert_to_pdf(file)

	local cmd = "pandoc -s -f markdown-implicit_figures --pdf-engine=xelatex "

	if vim.fn.executable('pandoc') == 0 or vim.fn.executable('xetex') == 0 or vim.fn.executable('latex') == 0 then
		vim.api.nvim_echo({{"pandoc not installed!", "WarningMsg"}}, true, {})
		vim.api.nvim_echo({{"Install pandoc ...", "MoreMsg"}}, true, {})
		pandoc_install()
	end

	if file == nil then
		vim.api.nvim_echo({{"Current Directroy: ", "MoreMsg"}}, true, {})
		print(vim.fn.system('ls'))
		file = vim.fn.input(">> File: ")
	end

	cmd = cmd .. file .. " -o " .. vim.fn.fnamemodify(file, ":t:r") .. ".pdf"

    print(vim.fn.system(cmd))
end

local ret = {
	ConvPdf = pandoc_convert_to_pdf,
	Install = pandoc_install,
}

vim.cmd("command! -nargs=* ConvPdf lua require('features.file').ConvPdf(<f-args>)")

return ret
