function _G.load_csv_filetype()
	if vim.fn.exists('did_load_csvfiletype') then
		return
	end

	local did_load_csvfiletype = 1

	if did_load_csvfiletype == 1 then
		vim.bo.filetype = 'csv'
	end
end

local function setup()
	vim.api.nvim_create_autocmd("BufRead", {
		desc = "csv format display",
		group = "format",
		pattern = "{*.csv,*.dat}",
		callback = function()
			_G.load_csv_filetype()
		end,
	})

	vim.api.nvim_create_autocmd("BufNewFile", {
		desc = "csv format display",
		group = "format",
		pattern = "{*.csv,*.dat}",
		callback = function()
			_G.load_csv_filetype()
		end,
	})
end

return {
	Setup = setup,
}
