local gs = require("gitsigns")

gs.setup({
	on_attach = function(bufnr)
		local bufopts = { buffer = bufnr }

		-- Hunk motion
		vim.keymap.set("n", "]c", function()
			vim.schedule(function()
				gs.next_hunk()
			end)
		end, bufopts)

		vim.keymap.set("n", "[c", function()
			vim.schedule(function()
				gs.prev_hunk()
			end)
		end, bufopts)

		-- Actions
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk, bufopts)
	end,
})
