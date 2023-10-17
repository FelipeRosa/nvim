vim.g.mapleader = " "

-- Explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- LSP commands
for _, mode in ipairs({ "n", "i", "v" }) do
    vim.keymap.set(mode, "<C-s>", vim.lsp.buf.signature_help)
end

-- venv selector
vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>")
vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>")
