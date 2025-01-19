return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-completion",
		"kristijanhusak/vim-dadbod-ui",
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

		-- Dynamically load connections from the project root
		-- local project_root = vim.fn.getcwd()
		-- local db_connections_path = project_root .. "/db_connections.lua"
		--
		-- -- Use dofile to load the Lua file
		-- local ok, connections = pcall(dofile, db_connections_path)
		-- if ok then
		-- 	vim.g.dbs = connections
		-- else
		-- 	vim.notify("Failed to load db_connections.lua from " .. db_connections_path, vim.log.levels.WARN)
		-- end

		-- Optional: Set key mappings
		vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { desc = "Toggle DB UI" })
		vim.keymap.set("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { desc = "Last Query Info" })
	end,
}
