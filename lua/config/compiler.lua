if io.open('ecfw-zephyr') then
	if io.open('ecfw-zephyr/build.sh') then
		vim.api.nvim_set_option('makeprg', [[cd $(west topdir)/$(west config manifest.path) && ./build.sh]])
	else
		vim.api.nvim_set_option('makeprg', [[west build -p=always -d $(west config manifest.path)/build $(west config manifest.path)]])
	end
end
