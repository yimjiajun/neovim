function _G.Toggle_venn()
	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	if venn_enabled == "nil" then
		vim.b.venn_enabled = true
		vim.cmd[[setlocal ve=all]]
		-- draw a line on HJKL keystokes
		vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
		vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
		-- draw a box by pressing "f" with visual selection
		vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
		vim.api.nvim_echo({{'[Enable] Draw Diagram', 'None'}}, false, {})
	else
		vim.cmd[[setlocal ve=]]
		vim.cmd[[mapclear <buffer>]]
		vim.b.venn_enabled = nil
		vim.api.nvim_echo({{'[Disable] Draw Diagram', 'None'}}, false, {})
	end
end

local function setup_keymapping()
	vim.api.nvim_set_keymap('n', '<leader>gv', ":lua Toggle_venn()<CR>", { silent = true, noremap = true })

	if pcall(require, 'which-key') then
		local wk = require('which-key')
		wk.register({
			v = "Venn (toggle draw diagram)",
			}, { mode = "n", prefix = "<leader>g" })
	end
end

local function setup()
	setup_keymapping()
end

return {
	Setup = setup,
}
