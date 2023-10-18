local telescope = require("telescope")
telescope.setup()

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", function()
	builtin.find_files({ no_ignore = true })
end)
vim.keymap.set("n", "<leader>gf", builtin.git_files)
vim.keymap.set("n", "<leader>ss", builtin.live_grep)

vim.keymap.set("n", "<leader>sb", builtin.buffers)
vim.keymap.set("n", "<leader>st", builtin.treesitter)

vim.keymap.set("n", "gt", "<cmd>Telescope lsp_document_symbols<cr>")
vim.keymap.set("n", "gT", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")
vim.keymap.set("n", "gL", "<cmd>Telescope diagnostics<cr>")
