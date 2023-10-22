local trouble = require("trouble")
trouble.setup()

vim.keymap.set("n", "<leader>xw", function()
	trouble.toggle("workspace_diagnostics")
end)
vim.keymap.set("n", "<leader>xd", function()
	trouble.toggle("document_diagnostics")
end)
