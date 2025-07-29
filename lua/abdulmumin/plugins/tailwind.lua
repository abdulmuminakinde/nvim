return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {},
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
		},
		opts = function(_, opts)
			-- Ensure formatting table exists
			opts.formatting = opts.formatting or {}

			-- Store original formatter if it exists
			local format_kinds = opts.formatting.format

			opts.formatting.format = function(entry, item)
				-- Apply original formatting if it exists
				if format_kinds then
					format_kinds(entry, item)
				end
				-- Apply tailwind colorizer formatting
				return require("tailwindcss-colorizer-cmp").formatter(entry, item)
			end
		end,
	},
}
