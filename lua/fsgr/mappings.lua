vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Buffers
vim.keymap.set("n", "<leader>c", "<cmd>bd<cr>")
vim.keymap.set("n", "<A-Right>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<A-Left>", "<cmd>bprevious<cr>")
