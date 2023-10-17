local diffview_opened = false

vim.keymap.set("n", "<leader>gd", function()
    if diffview_opened then
        vim.cmd("DiffviewClose")
    else
        vim.cmd("DiffviewOpen")
    end
end)

vim.api.nvim_create_autocmd("User", {
    pattern = "DiffviewViewOpened",
    callback = function()
        diffview_opened = true
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "DiffviewViewClosed",
    callback = function()
        diffview_opened = false
    end,
})
