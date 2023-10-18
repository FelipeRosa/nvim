vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Buffers
vim.keymap.set("n", "<leader>c", "<cmd>bd<cr>")
vim.keymap.set("n", "<A-Right>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<A-Left>", "<cmd>bprevious<cr>")
