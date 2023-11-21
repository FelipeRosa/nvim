require("nvim-tree").setup({
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	filters = {
		git_ignored = false,
	},
	diagnostics = {
		enable = true,
	},
})

local api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>e", api.tree.toggle)
vim.keymap.set("n", "<leader>E", function()
	api.tree.find_file({ open = true, update_root = true })
end)
