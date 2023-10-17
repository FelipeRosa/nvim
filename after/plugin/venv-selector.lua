require("venv-selector").setup()

vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>")
vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>")
