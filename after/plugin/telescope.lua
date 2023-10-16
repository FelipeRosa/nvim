local builtin = require("telescope.builtin")

-- Find files
vim.keymap.set("n", "<leader>sf", function()
    builtin.find_files({ no_ignore = true })
end)
-- Git files
vim.keymap.set("n", "<leader>gf", builtin.git_files)
-- Live grep
vim.keymap.set("n", "<leader>ss", builtin.live_grep)
