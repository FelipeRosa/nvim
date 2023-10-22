local M = {}

M.open_cargo_toml = function()
	local clients = vim.lsp.buf_get_clients()

	local root_dir = nil
	for _, client in pairs(clients) do
		if client.name == "rust_analyzer" then
			root_dir = client.config.root_dir
		end
	end

	if root_dir == nil then
		vim.notify("Not in a Rust project")
	else
		vim.cmd("e " .. root_dir .. "/Cargo.toml")
	end
end

M.reload_workspace = function()
	vim.notify("Rust workspace reload")
	vim.lsp.buf_request(0, "rust-analyzer/reloadWorkspace", nil, function(err)
		if err then
			error(tostring(err))
		end
		vim.notify("rust_analyzer workspace reloaded")
	end)
end

return M
