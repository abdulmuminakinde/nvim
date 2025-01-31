return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0,
			},
			win_options = {
				wrap = true,
				winblend = 0,
			},
			keymaps = {
				["<C-c>"] = false,
				["q"] = "actions.close",
				["<C-s>"] = false,
			},
		})
	end,
	-- view_options = {
	-- 	-- Show files and directories that start with "."
	-- 	show_hidden = true,
	-- 	-- This function defines what is considered a "hidden" file
	-- 	is_hidden_file = function(name, bufnr)
	-- 		local m = name:match("^%.")
	-- 		return m ~= nil
	-- 	end,
	-- 	-- This function defines what will never be shown, even when `show_hidden` is set
	-- 	is_always_hidden = function(name, bufnr)
	-- 		return false
	-- 	end,
	-- 	-- Sort file names with numbers in a more intuitive order for humans.
	-- 	-- Can be "fast", true, or false. "fast" will turn it off for large directories.
	-- 	natural_order = "fast",
	-- 	-- Sort file and directory names case insensitive
	-- 	case_insensitive = false,
	-- 	sort = {
	-- 		-- sort order can be "asc" or "desc"
	-- 		-- see :help oil-columns to see which columns are sortable
	-- 		{ "type", "asc" },
	-- 		{ "name", "asc" },
	-- 	},
	-- 	-- Customize the highlight group for the file name
	-- 	highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
	-- 		return nil
	-- 	end,
	-- },
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
}
