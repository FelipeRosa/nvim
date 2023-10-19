local venvSelector = require("venv-selector")

venvSelector.setup()

vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>")
vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>")

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	once = true,
	callback = function()
		local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
		if venv ~= "" then
			require("venv-selector").retrieve_from_cache()
		end
	end,
})
