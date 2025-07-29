return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- <-- Use this instead of copilot.vim
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {},
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- Disable popups/suggestions
			})
		end,
	},
}
