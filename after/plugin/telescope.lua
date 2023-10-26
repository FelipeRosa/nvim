local telescope = require("telescope")
telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", function()
	builtin.find_files({ no_ignore = true })
end)
vim.keymap.set("n", "<leader>gf", builtin.git_files)
vim.keymap.set("n", "<leader>ss", builtin.live_grep)

vim.keymap.set("n", "<leader>sb", builtin.buffers)
vim.keymap.set("n", "<leader>st", builtin.treesitter)
